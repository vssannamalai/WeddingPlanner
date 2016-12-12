using System;
using System.Collections.Generic;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business
{
    public class BankAccountComponent
    {
        /// <summary>
        /// If the supplied entity is "Supplier", then new record will be created in SupplierBankingDetails table
        /// If the supplied entity is "Community Owner", then new record will be created in OwnerBankingDetails table
        /// </summary>
        /// <param name="bankAccount"></param>       
        public void BankAccountUpdate(BankAccount bankAccount)
        {
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            bankAccountDAC.BankAccountUpdate(bankAccount);
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
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            return bankAccountDAC.BankingDetailsSelect(id, entity);
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
        public VirtualCommunityAccount DebitVirtualCommunityAccount(int id, string entity, int communityId, int? communityGroupId, string description, decimal amount, DateTime dateApplied, int? customerId)
        {
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            return bankAccountDAC.DebitVirtualCommunityAccount(id, entity, communityId,communityGroupId, description, amount, dateApplied, customerId);
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
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            return bankAccountDAC.CreditVirtualCommunityAccount(id, entity, communityId,communityGroupId, description, amount, dateApplied, customerId);
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
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            return bankAccountDAC.TransactionSelect(transactionHistoryId, entity);
        }

         /// <summary>
        /// 1. Triggers the ActionInsert procedure to handle any action responses as a result of this transaction - (NB: The ActionAmount is the supplied Amount, and the ActionDetail is "Customer Transaction")
        /// 2. Triggers the CreditVirtualCommunityAccount procedure to insert the transacted amount into the supplier's virtual community account
        /// </summary>
        /// <param name="virtualCommunityAccount"></param>
        public void TransactionInsert(VirtualCommunityAccount virtualCommunityAccount)
        {
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            bankAccountDAC.TransactionInsert(virtualCommunityAccount);
        }

        public void PaymentTransactionInsert(PaymentTransaction paymentTransaction)
        {
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            bankAccountDAC.PaymentTransactionInsert(paymentTransaction);
        }

        public void PaypalTransactionInsert(PaypalTransaction paypalTransaction)
        {
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            bankAccountDAC.PaypalTransactionInsert(paypalTransaction);
        }

        public PaypalTransaction PaypalTransactionSelect(string transactionId)
        {
            BankAccountDAC bankAccountDAC = new BankAccountDAC();
            return bankAccountDAC.PaypalTransactionSelect(transactionId);
        }
    }
}
