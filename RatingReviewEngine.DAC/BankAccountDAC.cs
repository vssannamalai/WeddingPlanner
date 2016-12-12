using System;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.DAC
{
    public class BankAccountDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// If the supplied entity is "Supplier", then new record will be created in SupplierBankingDetails table
        /// If the supplied entity is "Community Owner", then new record will be created in OwnerBankingDetails table
        /// </summary>
        /// <param name="bankAccount"></param>
        public void BankAccountUpdate(BankAccount bankAccount)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("BankAccountUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_ID", DbType.Int32, bankAccount.EnitiyID);
                objDb.AddInParameter(cmd, "IN_Entity", DbType.String, bankAccount.Entity);
                objDb.AddInParameter(cmd, "IN_Bank", DbType.String, bankAccount.Bank);
                objDb.AddInParameter(cmd, "IN_AccountName", DbType.String, bankAccount.AccountName);
                objDb.AddInParameter(cmd, "IN_BSB", DbType.String, bankAccount.BSB);
                objDb.AddInParameter(cmd, "IN_AccountNumber", DbType.String, bankAccount.AccountNumber);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. If the supplied entity is "Supplier", then select a record in the SupplierBankingDetails table
        /// 2. If the supplied entity is "Community Owner", then select a record in the OwnerBankingDetails table
        /// </summary>
        /// <param name="id"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        public BankAccount BankingDetailsSelect(int id, string entity)
        {
            BankAccount bankAccount = new BankAccount();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("BANKINGDETAILSSELECT"))
            {
                objDb.AddInParameter(cmd, "IN_ID", DbType.Int32, id);
                objDb.AddInParameter(cmd, "IN_Entity", DbType.String, entity);
                using (IDataReader drBankDetails = objDb.ExecuteReader(cmd))
                {
                    while (drBankDetails.Read())
                    {

                        bankAccount.EnitiyID = id;
                        bankAccount.Entity = entity;
                        bankAccount.Bank = drBankDetails["Bank"] == DBNull.Value ? "" : drBankDetails["Bank"].ToString();
                        bankAccount.AccountName = drBankDetails["AccountName"] == DBNull.Value ? "" : drBankDetails["AccountName"].ToString();
                        bankAccount.BSB = drBankDetails["BSB"] == DBNull.Value ? "" : drBankDetails["BSB"].ToString();
                        bankAccount.AccountNumber = drBankDetails["AccountNumber"] == DBNull.Value ? "" : drBankDetails["AccountNumber"].ToString();
                    }
                }
            }
            return bankAccount;
        }
        /// <summary>
        /// 1. If the supplied entity is "Supplier"
        /// a) retrieve the current balance for the supplier's community virtual account (SupplierCommunityTransactionHistory.Balance) based on the most recent transaction
        /// ( Max(SupplierCommunityTransactionHistory.DateApplied) ) for the given Supplier-Community relationship
        /// b) calculate the new balance for the supplier's community virtual account from the current balance and the debit amount (SupplierCommunityTransactionHistory.Balance - Amount)
        /// c) add a new transaction record to the supplier's community virtual account based on the calculated balance and the supplied details (SupplierCommunityTransactionHistory)
        /// 2. If the supplied entity is "Community Owner"
        /// a) retrieve the current balance for the community owner's community virtual account (CommunityOwnerTransactionHistory.Balance) based on the most recent transaction 
        /// ( Max(CommunityOwnerTransactionHistory.DateApplied) ) for the given Community Owner-Community relationship
        /// b) calculate the new balance for the community owner's community virtual account from the current balance and the debit amount (CommunityOwnerTransactionHistory.Balance - Amount)
        /// c) add a new transaction record to the community owner's community virtual account based on the calculated balance and the supplied details (CommunityOwnerTransactionHistory)
        /// </summary>
        /// <param name="id"></param>
        /// <param name="entity"></param>
        /// <param name="communityId"></param>
        /// <param name="description"></param>
        /// <param name="amount"></param>
        /// <param name="dateApplied"></param>
        /// <param name="customerId"></param>
        public VirtualCommunityAccount DebitVirtualCommunityAccount(int id, string entity, int communityId,int? communityGroupId, string description, decimal amount, DateTime dateApplied, int? customerId)
        {
            VirtualCommunityAccount virtualCommunityAccount = new VirtualCommunityAccount();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("DebitVirtualCommunityAccount"))
            {
                objDb.AddInParameter(cmd, "IN_ID", DbType.Int32, id);
                objDb.AddInParameter(cmd, "IN_Entity", DbType.String, entity);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, description);
                objDb.AddInParameter(cmd, "IN_Amount", DbType.Decimal, amount);
                objDb.AddInParameter(cmd, "IN_DateApplied", DbType.DateTime, dateApplied);
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerId);
                using (IDataReader drAccountDetails = objDb.ExecuteReader(cmd))
                {
                    while (drAccountDetails.Read())
                    {
                        if (entity.ToLower() == "community owner")
                        {
                            virtualCommunityAccount.CommunityOwnerTransactionHistoryID = Convert.ToInt32(drAccountDetails["communityownertransactionhistoryid"].ToString());
                            virtualCommunityAccount.OwnerID = Convert.ToInt32(drAccountDetails["OwnerID"].ToString());
                        }
                        else
                        {
                            virtualCommunityAccount.SupplierCommunityTransactionHistoryID = Convert.ToInt32(drAccountDetails["suppliercommunitytransactionhistoryid"].ToString());
                            virtualCommunityAccount.SupplierID = Convert.ToInt32(drAccountDetails["SupplierID"].ToString());
                            if (drAccountDetails["CustomerID"] != DBNull.Value)
                                virtualCommunityAccount.CustomerID = Convert.ToInt32(drAccountDetails["CustomerID"].ToString());
                        }

                        virtualCommunityAccount.CommunityID = Convert.ToInt32(drAccountDetails["CommunityID"].ToString());
                        if (drAccountDetails["CommunityGroupID"] != DBNull.Value)
                            virtualCommunityAccount.CommunityGroupID = Convert.ToInt32(drAccountDetails["CommunityGroupID"].ToString());
                        virtualCommunityAccount.Description = drAccountDetails["Description"].ToString();
                        virtualCommunityAccount.Amount = Convert.ToDecimal(drAccountDetails["Amount"].ToString());
                        virtualCommunityAccount.DateApplied = Convert.ToDateTime(drAccountDetails["DateApplied"]);
                        virtualCommunityAccount.Balance = Convert.ToDecimal(drAccountDetails["Balance"].ToString());

                    }
                }

            }
            return virtualCommunityAccount;
        }

        /// <summary>
        /// 1. If the supplied entity is "Supplier"
        /// a) retrieve the current balance for the supplier's community virtual account (SupplierCommunityTransactionHistory.Balance) based on the most recent transaction 
        /// ( Max(SupplierCommunityTransactionHistory.DateApplied) ) for the given Supplier-Community relationship
        /// b) calculate the new balance for the supplier's community virtual account from the current balance and the deposit amount (SupplierCommunityTransactionHistory.Balance + Amount)
        /// c) add a new transaction record to the supplier's community virtual account based on the calculated balance and the supplied details (SupplierCommunityTransactionHistory)
        /// 2. If the supplied entity is "Community Owner"
        /// a) retrieve the current balance for the community owner's community virtual account (CommunityOwnerTransactionHistory.Balance) based on the most recent transaction 
        /// ( Max(CommunityOwnerTransactionHistory.DateApplied) ) for the given Community Owner-Community relationship
        /// b) calculate the new balance for the community owner's community virtual account from the current balance and the deposit amount (CommunityOwnerTransactionHistory.Balance + Amount)
        /// c) add a new transaction record to the community owner's community virtual account based on the calculated balance and the supplied details (CommunityOwnerTransactionHistory)
        /// </summary>
        /// <param name="id"></param>
        /// <param name="entity"></param>
        /// <param name="communityId"></param>
        /// <param name="description"></param>
        /// <param name="amount"></param>
        /// <param name="dateApplied"></param>
        /// <param name="customerId"></param>
        public VirtualCommunityAccount CreditVirtualCommunityAccount(int id, string entity, int communityId,int? communityGroupId, string description, decimal amount, DateTime dateApplied, int? customerId)
        {
            VirtualCommunityAccount virtualCommunityAccount = new VirtualCommunityAccount();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CreditVirtualCommunityAccount"))
            {
                objDb.AddInParameter(cmd, "IN_ID", DbType.Int32, id);
                objDb.AddInParameter(cmd, "IN_Entity", DbType.String, entity);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, description);
                objDb.AddInParameter(cmd, "IN_Amount", DbType.Decimal, amount);
                objDb.AddInParameter(cmd, "IN_DateApplied", DbType.DateTime, dateApplied);
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerId);
                using (IDataReader drAccountDetails = objDb.ExecuteReader(cmd))
                {
                    while (drAccountDetails.Read())
                    {
                        if (entity.ToLower() == "community owner")
                        {
                            virtualCommunityAccount.CommunityOwnerTransactionHistoryID = Convert.ToInt32(drAccountDetails["CommunityOwnerTransactionHisotryID"].ToString());
                            virtualCommunityAccount.OwnerID = Convert.ToInt32(drAccountDetails["OwnerID"].ToString());
                        }
                        else
                        {
                            virtualCommunityAccount.SupplierCommunityTransactionHistoryID = Convert.ToInt32(drAccountDetails["SupplierCommunityTransactionHistoryID"].ToString());
                            virtualCommunityAccount.SupplierID = Convert.ToInt32(drAccountDetails["SupplierID"].ToString());
                            if (drAccountDetails["CustomerID"] != DBNull.Value)
                                virtualCommunityAccount.CustomerID = Convert.ToInt32(drAccountDetails["CustomerID"].ToString());
                        }

                        virtualCommunityAccount.CommunityID = Convert.ToInt32(drAccountDetails["CommunityID"].ToString());
                        if (drAccountDetails["CommunityGroupID"] != DBNull.Value)
                            virtualCommunityAccount.CommunityGroupID = Convert.ToInt32(drAccountDetails["CommunityGroupID"].ToString());
                        virtualCommunityAccount.Description = drAccountDetails["Description"].ToString();
                        virtualCommunityAccount.Amount = Convert.ToDecimal(drAccountDetails["Amount"].ToString());
                        virtualCommunityAccount.DateApplied = Convert.ToDateTime(drAccountDetails["DateApplied"]);
                        virtualCommunityAccount.Balance = Convert.ToDecimal(drAccountDetails["Balance"].ToString());

                    }
                }

            }
            return virtualCommunityAccount;
        }

        /// <summary>
        ///  1. The supplied entity is "Community Owner"
        ///  a) Retrieve the transaction record for the supplied TransactionHistoryID for the given Community Owner - Community (CommunityOwnerTransactionHistory.CommunityOwnerTransactionHistoryID)
        ///  2. The supplied entity is "Supplier"
        ///  a) Retrieve the transaction record for the supplied TransactionHistoryID for the given Supplier - Community (SupplierCommunityTransactionHistory.SupplierCommunityTransactionHistoryID)
        ///  3. Return the results
        /// </summary>
        /// <param name="transactionHistoryId"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        public VirtualCommunityAccount TransactionSelect(int transactionHistoryId, string entity)
        {
            VirtualCommunityAccount virtualCommunityAccount = new VirtualCommunityAccount();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("TransactionSelect"))
            {
                objDb.AddInParameter(cmd, "IN_TransactionHistoryID", DbType.Int32, transactionHistoryId);
                objDb.AddInParameter(cmd, "IN_Entity", DbType.String, entity);

                using (IDataReader drTransaction = objDb.ExecuteReader(cmd))
                {
                    while (drTransaction.Read())
                    {
                        if (entity.ToLower() == "community owner")
                        {
                            virtualCommunityAccount.CommunityOwnerTransactionHistoryID = Convert.ToInt32(drTransaction["CommunityOwnerTransactionHisotryID"].ToString());
                            virtualCommunityAccount.OwnerID = Convert.ToInt32(drTransaction["OwnerID"].ToString());
                        }
                        else
                        {
                            virtualCommunityAccount.SupplierCommunityTransactionHistoryID = Convert.ToInt32(drTransaction["SupplierCommunityTransactionID"].ToString());
                            virtualCommunityAccount.SupplierID = Convert.ToInt32(drTransaction["SupplierID"].ToString());
                            if (drTransaction["CustomerID"] != DBNull.Value)
                                virtualCommunityAccount.CustomerID = Convert.ToInt32(drTransaction["CustomerID"].ToString());
                        }

                        virtualCommunityAccount.CommunityID = Convert.ToInt32(drTransaction["CommunityID"].ToString());
                        if (drTransaction["CommunityGroupID"] != DBNull.Value)
                            virtualCommunityAccount.CommunityGroupID = Convert.ToInt32(drTransaction["CommunityGroupID"].ToString());
                        virtualCommunityAccount.Description = drTransaction["Description"].ToString();
                        virtualCommunityAccount.Amount = Convert.ToDecimal(drTransaction["Amount"].ToString());
                        virtualCommunityAccount.DateApplied = Convert.ToDateTime(drTransaction["DateApplied"]);
                        virtualCommunityAccount.Balance = Convert.ToDecimal(drTransaction["Balance"].ToString());
                    }
                }
            }

            return virtualCommunityAccount;
        }

        /// <summary>
        /// 1. Triggers the ActionInsert procedure to handle any action responses as a result of this transaction - (NB: The ActionAmount is the supplied Amount, and the ActionDetail is "Customer Transaction")
        /// 2. Triggers the CreditVirtualCommunityAccount procedure to insert the transacted amount into the supplier's virtual community account
        /// </summary>
        /// <param name="virtualCommunityAccount"></param>
        public void TransactionInsert(VirtualCommunityAccount virtualCommunityAccount)
        {
            DbCommand cmd;
            using(cmd=(DbCommand)objDb.GetStoredProcCommand("transactioninsert"))
            {
                objDb.AddInParameter(cmd, "in_customerid", DbType.Int32, virtualCommunityAccount.CustomerID);
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, virtualCommunityAccount.SupplierID);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, virtualCommunityAccount.CommunityID);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, virtualCommunityAccount.CommunityGroupID);
                objDb.AddInParameter(cmd,"in_description",DbType.String,virtualCommunityAccount.Description);
                objDb.AddInParameter(cmd,"in_amount",DbType.Decimal,virtualCommunityAccount.Amount);
                objDb.AddInParameter(cmd,"in_dateapplied",DbType.DateTime,virtualCommunityAccount.DateApplied);
                objDb.AddInParameter(cmd, "in_actionid", DbType.Int32, virtualCommunityAccount.ActionID);
                objDb.AddInParameter(cmd, "in_communityownerid", DbType.Int32, virtualCommunityAccount.OwnerID);
                
                objDb.ExecuteNonQuery(cmd);
            }
        }

        public void PaymentTransactionInsert(PaymentTransaction paymentTransaction)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("paymenttransactioninsert"))
            {
                objDb.AddInParameter(cmd, "in_oauthaccountid", DbType.Int32, paymentTransaction.OAuthAccountID);
                objDb.AddInParameter(cmd, "in_transactionamount", DbType.Decimal, paymentTransaction.TransactionAmount);
                objDb.AddInParameter(cmd, "in_ordercode", DbType.String, paymentTransaction.OrderCode);
                objDb.AddInParameter(cmd, "in_echodata", DbType.String, paymentTransaction.EchoData);
                objDb.AddInParameter(cmd, "in_successmessage", DbType.String, paymentTransaction.SuccessMessage);
                objDb.AddInParameter(cmd, "in_errormessagae", DbType.String, paymentTransaction.ErrorMessage);
                objDb.AddInParameter(cmd, "in_responsexml", DbType.String, paymentTransaction.ResponseXML);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        public void PaypalTransactionInsert(PaypalTransaction paypalTransaction)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("paypaltransactioninsert"))
            {
                objDb.AddInParameter(cmd, "in_oauthaccountid", DbType.Int32, paypalTransaction.OAuthAccountID);
                objDb.AddInParameter(cmd, "in_transactionid", DbType.String, paypalTransaction.TransactionID);
                objDb.AddInParameter(cmd, "in_responsemessage", DbType.String, paypalTransaction.ResponseMessage);
                objDb.AddInParameter(cmd, "in_status", DbType.String, paypalTransaction.Status);
                objDb.AddInParameter(cmd, "in_responsetext", DbType.String, paypalTransaction.ResponseText);
                objDb.AddInParameter(cmd, "in_transactiondate", DbType.DateTime, paypalTransaction.TransactionDate);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        public PaypalTransaction PaypalTransactionSelect(string transactionId)
        {
            PaypalTransaction transaction = new PaypalTransaction();
            transaction.TransactionDate = DateTime.Now;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("paypaltransactionselect"))
            {
                objDb.AddInParameter(cmd, "in_transactionid", DbType.String, transactionId);

                using (IDataReader drTransaction = objDb.ExecuteReader(cmd))
                {
                    while (drTransaction.Read())
                    {
                        transaction.PaypalTransactionID = Convert.ToInt32(drTransaction["paypaltransactionid"].ToString());
                        transaction.OAuthAccountID = Convert.ToInt32(drTransaction["oauthaccountid"].ToString());
                        transaction.TransactionID = drTransaction["transactionid"].ToString();
                        transaction.ResponseMessage = drTransaction["responsemessage"].ToString();
                        transaction.Status = drTransaction["status"].ToString();
                        transaction.ResponseText = drTransaction["responsetext"].ToString();
                        transaction.TransactionDate = Convert.ToDateTime(drTransaction["transactiondate"]);
                    }
                }
            }
            return transaction;
        }
    }
}
