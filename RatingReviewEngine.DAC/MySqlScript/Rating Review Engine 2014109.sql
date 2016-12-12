CREATE DATABASE  IF NOT EXISTS `ratingreviewengine` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ratingreviewengine`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: 192.168.0.111    Database: ratingreviewengine
-- ------------------------------------------------------
-- Server version	5.6.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'ratingreviewengine'
--
/*!50003 DROP FUNCTION IF EXISTS `stringSplit` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `stringSplit`(
x VARCHAR(255),
delim VARCHAR(12),
pos INT) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1), delim, '') ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `accessrightselectall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `accessrightselectall`()
BEGIN
-- -------------comment-------------------
-- get all accessright
-- ----------------------------------------

		select p.pageId,p.pagename,
		  coalesce( max(case when userroleid = 1 then coalesce(allowed,0) end),0) administrator,
		   coalesce(max(case when userroleid = 2 then coalesce(allowed,0) end),0) owner,
		   coalesce(max(case when userroleid = 3 then coalesce(allowed,0) end),0) supplier
	
		from pages p left join accessrights a on p.pageid=a.pageid
		group by p.pageId order by p.pagename;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accessrightselectbyoauthaccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `accessrightselectbyoauthaccount`(
in in_oauthaccountid int
)
BEGIN
-- ----------------comment--------------------------
-- Get access allowed page 
-- -------------------------------------------------
		
				select p.pageid,pagename from accessrights ar inner join pages p on ar.pageid=p.pageid
				where ar.userroleid =1 and allowed=1 and 1=(select administrator from usersecurity where oauthaccountid=in_oauthaccountid )
					union
				select p.pageid,pagename from accessrights ar inner join pages p on ar.pageid=p.pageid
				where ar.userroleid =2 and allowed=1 and 1=(select communityowner from usersecurity where oauthaccountid=in_oauthaccountid )
					union
				select p.pageid,pagename from accessrights ar inner join pages p on ar.pageid=p.pageid
				where ar.userroleid =3 and allowed=1 and 1=(select supplier from usersecurity where oauthaccountid=in_oauthaccountid );
					
	

		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accessrightselectbyrole` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `accessrightselectbyrole`(
in in_userroleid int
)
BEGIN
-- ---------------comment---------------
-- Get accessright 
-- -------------------------------------

		select p.pageid,pagename from accessrights ar inner join pages p on ar.pageid=p.pageid
		where ar.userroleid=in_userroleid and allowed=1;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accessrightupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `accessrightupdate`(
in in_pageid int,
in in_adminallowed bit,
in in_ownerallowed bit,
in in_supplierallowed bit
)
BEGIN

		if(exists(select accessrightid from accessrights where pageid=in_pageid and userroleid=1)) then
			update accessrights set allowed=in_adminallowed where pageid=in_pageid and userroleid=1;
		else
			insert into accessrights(pageid,userroleid,allowed) values(in_pageid,1,in_adminallowed);
		end if;

		if(exists(select accessrightid from accessrights where pageid=in_pageid and userroleid=2)) then
			update accessrights set allowed=in_ownerallowed where pageid=in_pageid and userroleid=2;
		else
			insert into accessrights(pageid,userroleid,allowed) values(in_pageid,2,in_ownerallowed);
		end if;

		if(exists(select accessrightid from accessrights where pageid=in_pageid and userroleid=3)) then
			update accessrights set allowed=in_supplierallowed where pageid=in_pageid and userroleid=3;
		else
			insert into accessrights(pageid,userroleid,allowed) values(in_pageid,3,in_supplierallowed);
		end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accountactivate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `accountactivate`(
in in_provideruserid varchar(200)
)
begin
-- -------------comment----------------------------------
-- 
-- ------------------------------------------------------

    if(exists(select oauthaccountid from oauthaccount where provideruserid=in_provideruserid and provider='general')) then
        begin
            update oauthaccount set active=true where provideruserid=in_provideruserid and provider='general';
            select 'valid' as result;
        end;
    else
        select 'invalid' as result;
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `actioninsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `actioninsert`(
in in_communityid int,
in in_communitygroupid int,
in in_actionid int,
in in_communityownerid int,
in in_supplierid int,
in in_customerid int,
in in_actiondetails varchar(200),
in in_actionamt decimal(10,2),
in in_parentsupplieractionid int,
out out_supplieractionid int
)
begin
-- -------comment-------------------------------------------
-- 1. if the given action is active (triggeredevent.isactive) then the procedure continues, else it ends here
-- 2. a record of the action is to be logged against the given supplier (supplieraction)
-- 3. if a value was supplied for the @actionamt input parameter, then an additional record of financial activity is to be logged (suppliertransactions) - 
--      (nb: the 'isquote' flag can be derived from the action table - if action.name like '%quote%', then this flag is true)
-- 3. if the given supplier is not currently within a bill free override (suppliercommunitybillfreeoverride.isactive = true) then the procedure continues - 
--      (nb: even if the fee is 0, this process will still continue). if the isactive flag is false, then the procedure is to end.
-- 4. the community owner is to have their virtual community account (communityownertransactionhistory) credited by the calculated @communityownerincome 
--      (communitygroupbillingfee.fee * triggeredevent.billingpercentageowner)
-- 5. the supplier's virtual community account (suppliertransactionhistory) is to be debited the full fee amount (communitygroupbillingfee.fee) in the fee's 
--      currency (communitygroupbillingfee.feecurrencyid)
-- 6. add a billing reference to ensure that the supplier transaction record is linked to the community owner transaction record (billingreference)
-- 7. if there is a customer reward associated with the triggered event for the given community (communityreward.points), then add the points to the given
--      customer's points tally (customerpointstally), and also record a record of the reward for the given customer (customerrewards)
-- insert supplier action 
-- if action amount entered add supplier transaction record. 
-- if bill free override period exist for the supplier for that particular community / community group . end the procedure
-- if supplier not in bill free period  , derive respective fees amount for the supplier and add the fee transaction
--   check if the action is in bill free period for the 
-- derive  owner income based on the fees settings 
-- credit the income to owner account
-- ---------------------------------------------------------

    declare v_currency int;
	declare v_actionname varchar(50);
	declare v_actiondetails varchar(500);

	declare v_isquote bit;

    declare v_communityownerincome decimal(10,2);
    declare v_communityownertransactionhistoryid int;

    declare v_adminincome decimal(10,2);
    declare v_admintransactionhistoryid int;

	declare v_supplierfee decimal(10,2);
    declare v_suppliertransactionhistoryid int;

    declare v_points int;
	declare v_communitygrouprewardid int;

	declare v_billingpercentageadministrator decimal(10,2);
	declare v_billingpercentageowner decimal(10,2);

	declare v_fee decimal(10,2);
	declare v_feecurrencyid int;
	declare v_ispercentfee bit;

	declare v_triggeredeventsid  int;

	

   /* declare exit handler for sqlexception
      begin
        -- error
      resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
     -- resignal;
     -- rollback;
    end;*/
    
   -- start transaction;
    
    -- if the given action is active (triggeredevent.isactive)
    if(exists(select triggeredeventid from triggeredevent where actionid=in_actionid and isactive=true)) then
    begin
    
			select name ,  if(name like '%quote%',1,0) as isquote into v_actionname  , v_isquote from actions where actionid = in_actionid;
            


            insert into supplieraction(customerid,supplierid,communityid,communitygroupid,actionid,actiondate,detail,responseactionperformed,parentsupplieractionid)
                values(in_customerid,in_supplierid,in_communityid,in_communitygroupid,in_actionid,now(),in_actiondetails,true,in_parentsupplieractionid);
            
            set out_supplieractionid=last_insert_id();
            
           -- select * from supplieraction where supplierid=in_supplierid;
            
    -- if a value was supplied for the @actionamt input parameter        
            if(in_actionamt is not null and in_actionamt>0) then
            begin
                
                set v_currency=(select currencyid from communitygroup where communitygroupid=in_communitygroupid);
                
                insert into suppliertransactions(supplieractionid,customerid,supplierid,communityid,communitygroupid,transactionamount,isquote,currencyid)
                    values(last_insert_id(),in_customerid,in_supplierid,in_communityid,in_communitygroupid,in_actionamt,v_isquote,v_currency);
           
             end;
            end if; 

        -- if the given supplier is not currently within a bill free override
         /*  if(not exists(select isactive from suppliercommunitybillfreeoverride where communityid=in_communityid and communitygroupid=in_communitygroupid
                            and supplierid=in_supplierid and isactive=true and (billfreeend is null or billfreeend > now())   )) then
                           
  end if;-- end supplier not in billfree override
    end;*/

	-- if supplier bill applicable for the input action 
	if (exists(
		select  cgs.communitygroupid
		-- date_add(datejoined,interval billfreedays day) as billfreedate 
		 from communitygroupsupplier cgs
		inner join communitygroupbillingfee cgfee on cgs.communitygroupid = cgfee.communitygroupid
		inner join triggeredevent te on te.triggeredeventid = cgfee.triggeredeventid
		where te.isactive = 1 and cgs.supplierid = in_supplierid and cgs.communitygroupid = in_communitygroupid and te.actionid = in_actionid
		and date_add(datejoined,interval billfreedays day) < now()
	)) then 
	begin
	 select 'supplier not in bill free period'  as debugmessage;

		-- get fees details 
		select   billingpercentageadministrator , billingpercentageowner , fee , feecurrencyid, ispercentfee
		into   v_billingpercentageadministrator , v_billingpercentageowner , v_fee , v_feecurrencyid, v_ispercentfee
		  from communitygroupsupplier cgs
		inner join communitygroupbillingfee cgfee on cgs.communitygroupid = cgfee.communitygroupid
		inner join triggeredevent te on te.triggeredeventid = cgfee.triggeredeventid
		where te.isactive = 1 and cgs.supplierid = in_supplierid and cgs.communitygroupid = in_communitygroupid and te.actionid = in_actionid
		and date_add(datejoined,interval billfreedays day) < now();
		-- select v_billingpercentageadministrator , v_billingpercentageowner , v_fee , v_feecurrencyid, v_ispercentfee ;


		if (v_ispercentfee = 1 and in_actionamt > 0  ) then  
		begin
		 set v_supplierfee = in_actionamt * v_fee / 100 ;
		end ;
		else
		begin
		 set v_supplierfee = v_fee  ;
		end ;
		end if;


		-- select v_communityownerincome , v_supplierfee , v_billingpercentageowner;
		select  (v_supplierfee * v_billingpercentageowner ) / 100 as ownerincome , (v_supplierfee * v_billingpercentageadministrator ) / 100 as adminincome 
		into v_communityownerincome , v_adminincome ;


	 
	-- select v_communityownerincome , v_supplierfee;
  -- if actiondetail was emmpty yhen get action name based on action id
			if(in_actiondetails !='') then
			set v_actiondetails=in_actiondetails;
			else
			set v_actiondetails=v_actionname;
			end if;

 -- set v_actiondetails = concat(  v_actionname ,' ',  if( in_actiondetails is null , '' , in_actiondetails) ); action name was already passed to this procedure
				
				  call creditvirtualcommunityaccount(in_communityownerid,'community owner',in_communityid,in_communitygroupid,v_actiondetails   ,v_communityownerincome,now(),in_customerid);
				  set v_communityownertransactionhistoryid = last_insert_id();
					-- pass 0 as entity id for admin 
				  call creditvirtualcommunityaccount(0,'admin',in_communityid,in_communitygroupid,v_actiondetails,v_adminincome,now(),in_customerid);
				  set v_admintransactionhistoryid = last_insert_id();
	 
	-- need to clarify whether to update supplier fee based on the action or action amount used in action insert
				  call debitvirtualcommunityaccount(in_supplierid,'supplier',in_communityid,in_communitygroupid,v_actiondetails,v_supplierfee,now(),in_customerid);
				  set v_suppliertransactionhistoryid = last_insert_id();
							 
				  insert into billingreference(communityownertransactionhistoryid,suppliercommunitytransactionhistoryid,admintransactionhistoryid)
					values(v_communityownertransactionhistoryid,v_suppliertransactionhistoryid,v_admintransactionhistoryid);
					

	end;
	end if; -- end updating billing transaction

			set v_points = -1; 
			select  points , r.communitygrouprewardid ,  e.triggeredeventid into  
			v_points , v_communitygrouprewardid , v_triggeredeventsid from
			 communitygroupreward r 
			inner join triggeredevent e  on e.triggeredeventid = r.triggeredeventsid
			where e.actionid = in_actionid and  r.communitygroupid = in_communitygroupid ;

			select v_points ;
				if( v_points > 0 ) then
				begin 
				-- insert customer reward details
					insert into customerrewards(communityid,customerid,rewarddate,communitygrouprewardid,rewardname,rewarddescription,pointsapplied, triggeredeventsid,communitygroupid) 
					values  (in_communityid,in_customerid,now(),v_communitygrouprewardid,in_actiondetails,in_actiondetails,v_points, v_triggeredeventsid,in_communitygroupid);
				-- update customer points tally table  
					if exists(select * from customerpointstally where customerid = in_customerid  and communityid = in_communityid) then 
								 update customerpointstally
								set pointstally = pointstally + v_points where customerid = in_customerid and communityid = in_communityid;
					else
								 insert into customerpointstally(customerid,communityid,pointstally) 
											values(in_customerid,in_communityid,v_points);
					end if;
				end;        
                end if; -- end updating reward points
          end;
    end if; 
    
  -- commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `actionlist` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `actionlist`()
begin
-- ------------------------------comment----------------
-- get all action
-- -----------------------------------------------------

    select sql_no_cache actionid, name from actions order by name;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `actionresponseselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `actionresponseselect`(
in in_actionid int
)
BEGIN
-- ------------------comment---------------------------------
-- Get action response by actionid
-- ----------------------------------------------------------

            select ar.actionresponseid,ar.actionid,ar.responseid,a.name as actionname,a1.name as responsename
            from actions a inner join actionresponse ar on a.actionid=ar.actionid
                 inner join actions a1 on a1.actionid=ar.responseid
            where ar.actionid=in_actionid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `actionresponseselectwithoutRespondAndQuote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `actionresponseselectwithoutRespondAndQuote`(
in in_actionid int,
in in_supplieractionid int
)
BEGIN
-- -----------------comment-----------------------------------
-- Get actionreponse without Request / Quote
-- -----------------------------------------------------------

            select ar.actionresponseid,ar.actionid,ar.responseid,a.name as actionname,a1.name as responsename
            from supplieraction sa inner join actions a on sa.actionid=a.actionid   
				inner join actionresponse ar on a.actionid=ar.actionid
                 inner join actions a1 on a1.actionid=ar.responseid
				inner join triggeredevent te on te.actionid=a1.actionid
				left join supplieraction sa1 on sa1.ParentSupplierActionId=sa.supplieractionid and sa1.actionid=ar.responseid
            where ar.actionid=in_actionid and te.isactive=1 and sa.supplieractionid=in_supplieractionid  and sa1.SupplierActionID is null
					and a1.name not like concat('%','Respond','%') and a1.name not like concat('%','Quote','%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `actionselectactive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `actionselectactive`()
BEGIN
-- --------------comment----------------
-- Get active actions
-- -------------------------------------

		 select sql_no_cache a.actionid, name 
			from actions a inner join triggeredevent te on te.actionid=a.actionid
			where isactive=1 order by name; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admintransactionselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `admintransactionselect`(
in in_ownerid int,
in in_currencyid int,
in in_fromdate date,
in in_todate date,
in in_rowindex int,
in in_rowcount int
)
BEGIN
-- --------------------------comment----------------------------------------

-- -------------------------------------------------------------------------

if(in_rowindex = 0 and in_rowcount = 0) then
begin
select SQL_CALC_FOUND_ROWS o.ownerid,o.companyname,ct.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
         ,coalesce(cu.firstname,'n/a') as customername,ct.dateapplied,ct.amount,coalesce(s.companyname,'n/a') as suppliername,cur.currencyid,cur.isocode as currencyname

	 from admintransactionhistory ct inner join community c on ct.communityid=c.communityid
			inner join owner o on o.ownerid=c.ownerid
			inner join currency cur on cur.currencyid=c.currencyid
            left join communitygroup cg on ct.communitygroupid=cg.communitygroupid 
            left join billingreference b on b.admintransactionhistoryid=ct.admintransactionhistoryid
            left join suppliercommunitytransactionhistory st on st.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid
            left join supplier s on st.supplierid=s.supplierid
            left join customer cu on st.customerid=cu.customerid

        where  (c.ownerid=in_ownerid or in_ownerid=0) and (cur.currencyid=in_currencyid or in_currencyid=0)
		     and (date(ct.dateapplied)>=date(in_fromdate) or in_fromdate is null) 
			and (date(ct.dateapplied)<=date(in_todate) or in_todate is null)
        order by ct.dateapplied desc;

	
end;
else
begin
select SQL_CALC_FOUND_ROWS o.ownerid,o.companyname,ct.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
         ,coalesce(cu.firstname,'n/a') as customername,ct.dateapplied,ct.amount,coalesce(s.companyname,'n/a') as suppliername,cur.currencyid,cur.isocode as currencyname

	 from admintransactionhistory ct inner join community c on ct.communityid=c.communityid
			inner join owner o on o.ownerid=c.ownerid
			inner join currency cur on cur.currencyid=c.currencyid
            left join communitygroup cg on ct.communitygroupid=cg.communitygroupid 
            left join billingreference b on b.admintransactionhistoryid=ct.admintransactionhistoryid
            left join suppliercommunitytransactionhistory st on st.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid
            left join supplier s on st.supplierid=s.supplierid
            left join customer cu on st.customerid=cu.customerid

        where  (c.ownerid=in_ownerid or in_ownerid=0) and (cur.currencyid=in_currencyid or in_currencyid=0)
		     and (date(ct.dateapplied)>=date(in_fromdate) or in_fromdate is null) and (date(ct.dateapplied)<=date(in_todate) or in_todate is null)
        order by ct.dateapplied desc limit in_rowindex,in_rowcount;

	
end;
end if;

SELECT FOUND_ROWS() as totalrecords;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admintransactionsummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `admintransactionsummary`()
BEGIN

		select ownerid,companyname,sum(balance) as balance ,currencyid,currencyname from
		(
			select o.ownerid,o.companyname
			,coalesce( (select sum(balance) from admintransactionhistory 
			where admintransactionhistoryid=(select max(admintransactionhistoryid) from admintransactionhistory where communityid=c.communityid
		)
			),0) as balance,cu.currencyid,cu.isocode as currencyname
			
			from owner o inner join community c on o.ownerid=c.ownerid left join admintransactionhistory ath on ath.communityid=c.communityid
				left join currency cu on cu.currencyid=c.currencyid
			
			group by c.communityid
) as tbl group by ownerid,currencyid;


		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apitokenactivate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `apitokenactivate`(

in in_applicationid int,
in in_apitoken varchar(50)
)
begin
-- comment ------------------------------------------------------------------
-- 1. generate a new api token and update the application record to save the token (applicationauthentication.apitoken & applicationauthentication.tokengenerated)
-- 2. activate the api token (applicationauthentication.isactive = true)
-- ----------------------------------------------------------------------------
     
     update applicationauthentication set isactive=true,apitoken=in_apitoken,tokengenerated=now() where applicationid=in_applicationid;
     
     select applicationid,applicationname,tokengenerated,apitoken,lastconnection,isactive,registeredemail,communityid 
            from applicationauthentication where applicationid=in_applicationid;
     
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apitokendeactivate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `apitokendeactivate`(
in in_applicationid int
)
begin
-- ---------comment------------------
-- 1. update the application record and deactivate the api token associated to the registered application (applicationauthentication.isactive = false)
-- ----------------------------------

        update applicationauthentication set isactive = false where applicationid = in_applicationid;

		 select applicationid,applicationname,apitoken,registeredemail
			from applicationauthentication where applicationid=in_applicationid;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apitokenresend` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `apitokenresend`(
in in_applicationid int
)
BEGIN
	select applicationid,applicationname,tokengenerated,apitoken,lastconnection,isactive,registeredemail,communityid 
	from applicationauthentication where applicationid=in_applicationid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apitokenreset` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `apitokenreset`(
in in_applicationid int,
in in_apitoken varchar(50),
in in_tokengenerated datetime
)
begin
-- ------------------comment-----------------------------
-- 1. generate a new api token and update the application record to save the token (applicationauthentication.apitoken & applicationauthentication.tokengenerated)
-- 2. activate the api token (applicationauthentication.isactive = true)
-- ------------------------------------------------------

        update applicationauthentication set apitoken=in_apitoken,isactive=true,tokengenerated=in_tokengenerated where applicationid=in_applicationid;
        
        select applicationid,applicationname,tokengenerated,apitoken,lastconnection,isactive,registeredemail,communityid 
            from applicationauthentication where applicationid=in_applicationid;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `applicationauthenticationselectall` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `applicationauthenticationselectall`(
in in_ownerid int
)
BEGIN
-- --------------comment---------------------------------------------------
-- if owner id passed then get all application related to owner
-- else get all application
-- ------------------------------------------------------------------------

    select c.communityid,applicationid,o.ownerid,c.active as communityactive
        ,companyname as ownername,c.name as communityname,registeredemail,applicationname,apitoken,IsActive
    from applicationauthentication aa inner join community c on aa.communityid=c.communityid
    inner join owner o on c.ownerid=o.ownerid where (c.ownerid=in_ownerid or in_ownerid=0);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `applicationinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `applicationinsert`(
in in_applicationname varchar(50),
in in_registeredemail varchar(200),
in in_communityid int
)
begin
-- --------------comment---------------------------------------------
-- 1. save the given application details (applicationauthentication)
-- ------------------------------------------------------------------
        insert into applicationauthentication (applicationname,registeredemail,communityid,isactive)
        values(in_applicationname,in_registeredemail,in_communityid,false);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `bankaccountupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `bankaccountupdate`(
in in_id int,
in in_entity varchar(50),
in in_bank varchar(50),
in in_accountname varchar(50),
in in_bsb varchar(10),
in in_accountnumber varchar(20)
)
begin
        
-- -------------comment------------------------------
-- 1. if the supplied entity is "supplier", then create a new record in the supplierbankingdetails table
-- 2. if the supplied entity is "community owner", then create a new record in the ownerbankingdetails table
-- --------------------------------------------------

    if(in_entity='supplier') then
    begin
        if(exists(select supplierid from supplierbankingdetails where supplierid=in_id)) then
            
            update supplierbankingdetails set bank=in_bank, accountname=in_accountname,bsb=in_bsb,accountnumber=in_accountnumber where supplierid=in_id;
        else
        
            insert into supplierbankingdetails (supplierid,bank,accountname,bsb,accountnumber)
            values (in_id,in_bank,in_accountname,in_bsb,in_accountnumber);
            
        end if;
    
    end;
    
    elseif(in_entity='community owner') then
    begin
        if(exists(select ownerid from ownerbankingdetails where ownerid=in_id)) then
        
            update ownerbankingdetails set bank=in_bank,accountname=in_accountname,bsb=in_bsb,accountnumber=in_accountnumber where ownerid=in_id;
        else
        
            insert into ownerbankingdetails (ownerid,bank,accountname,bsb,accountnumber)
            values (in_id,in_bank,in_accountname,in_bsb,in_accountnumber);
        end if;
    end;
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `bankingdetailsselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `bankingdetailsselect`(
in in_id int,
in in_entity varchar(50)
)
begin
-- ---------------comment-------------------------------------
-- 1. if the supplied entity is "supplier", then select a record in the supplierbankingdetails table
-- 2. if the supplied entity is "community owner", then select a record in the ownerbankingdetails table
-- -----------------------------------------------------------

        if(in_entity='supplier') then
            select supplierid,bank,accountname,bsb,accountnumber from supplierbankingdetails where supplierid=in_id;
          
        elseif(in_entity='community owner') then
            select ownerid,bank,accountname,bsb,accountnumber from ownerbankingdetails where ownerid=in_id;
          
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `billfreeenddateupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `billfreeenddateupdate`(
in in_currentdate datetime
)
BEGIN
-- -------------------comment-------------

-- ---------------------------------------

	/*	select SupplierCommunityBillFreeOverrideID,BillFreeEnd from suppliercommunitybillfreeoverride
		where date_format(BillFreeEnd,'%d-%m-%Y')<= date_format(in_currentdate,'%d-%m-%Y') and isactive=1;

		update SupplierCommunityBillFreeOverride t1 inner join SupplierCommunityBillFreeOverride t2 
		on t1.SupplierCommunityBillFreeOverrideid=t2.SupplierCommunityBillFreeOverrideid set t1.isactive=0 
		where date_format(t1.BillFreeEnd,'%d-%m-%Y')<= date_format(in_currentdate,'%d-%m-%Y');*/



		update SupplierCommunityBillFreeOverride t1 set t1.isactive=0 
		where date_format(t1.BillFreeEnd,'%d-%m-%Y')<= date_format(in_currentdate,'%d-%m-%Y');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `billfreeoverrideupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `billfreeoverrideupdate`(
in in_suppliercommunitybillfreeoverrideid int,
in in_isactive bit,
in in_billfreeend datetime
)
begin
-- ---------------comment-------------------------
-- 1. update the relevant bill free override record with the supplied details (suppliercommunitybillfreeoverride) 
-- - (nb - if the supplied billfreeend date is null/emtpy, then do not update this date - only update this field if a date is supplied.)
-- -----------------------------------------------

    update suppliercommunitybillfreeoverride set isactive=in_isactive where suppliercommunitybillfreeoverrideid=in_suppliercommunitybillfreeoverrideid;
    
    if (in_billfreeend is not null or in_billfreeend!='') then
    update suppliercommunitybillfreeoverride set billfreeend=in_billfreeend where suppliercommunitybillfreeoverrideid=in_suppliercommunitybillfreeoverrideid;
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `checkapplicationexist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checkapplicationexist`(
in in_applicationname varchar(50)
)
BEGIN

		if(exists(select applicationid from applicationauthentication where applicationname=in_applicationname)) then
				select 1;
		else	
				select 0;
		end if;
			
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkcommunitygroupnameexist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checkcommunitygroupnameexist`(
in in_communitygroupid int,
in in_communityid int,
in in_name varchar(50)
)
BEGIN
-- -----------------comment-------------------------------------
-- check community group name exist
-- if exist return 1 else return 0
-- -------------------------------------------------------------

    if(exists(select communitygroupid from communitygroup where name=in_name and communityid=in_communityid and communitygroupid!=in_communitygroupid)) then
        select 1;
    else 
        select 0;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkcommunitynameexist` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checkcommunitynameexist`(
in in_communityid int,
in in_name varchar(50)
)
begin
-- -----------------comment-------------------------------------
-- check community name exist
-- if exist return 1 else return 0
-- -------------------------------------------------------------

    if(exists(select communityid from community where name=in_name and communityid!=in_communityid)) then
        select 1;
    else 
        select 0;
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `checkcurrencyexist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checkcurrencyexist`(
in in_currencyid int,
in in_isocode varchar(3),
in in_description varchar(50)
)
BEGIN
-- --------comment------------------------------------------
-- if isocode exist then return 1
-- if description exist then return 2
-- if both exist then return 3
-- ----------------------------------------------------------
	declare isisoexist int;
	declare isdescexist int;
	declare isexist int;
		set isexist=0;
		set isisoexist=0;
		set isdescexist=0;

		if(in_isocode!='') then
			if(exists(select currencyid from currency where isocode=in_isocode and currencyid!=in_currencyid)) then
				set isisoexist=1;
			end if;
		end if;

		if(in_description!='') then
			if(exists(select currencyid from currency where description=in_description and currencyid!=in_currencyid)) then
				set isdescexist=1;
			end if;
		end if;

		if(isisoexist=1) then
			set isexist=1;
		end if;
		
		if(isdescexist=1) then
		set isexist=2;
		end if;

		if(isisoexist=1 and isdescexist=1) then
			set isexist=3;
		end if;

		select isexist;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkowneremailexist` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checkowneremailexist`(
in in_ownerid int,
in in_email varchar(150)
)
begin
-- -------------comment---------------------------------------
-- check owner email is already exist
-- if exist return 1 else return 0
-- -----------------------------------------------------------

    if(exists(select ownerid from owner where email=in_email and ownerid!=in_ownerid)) then
        select 1;
    else
        select 0;
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `checksuppliercompanynameexist` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checksuppliercompanynameexist`(
in in_supplierid int,
in in_companyname varchar(50)
)
begin
-- --------------------comment-----------------------------------------
-- check supplier compnay name already exist
-- if exists return 1 else return 0
-- --------------------------------------------------------------------

    if(exists(select supplierid from supplier where companyname=in_companyname and supplierid!=in_supplierid)) then
        select 1;
    else
        select 0;
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `checksupplieremailexist` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `checksupplieremailexist`(
in in_supplierid int,
in in_email varchar(150)
)
begin
-- -----------------comment---------------------------------------
-- check supplier email is already exist
-- if exist return 1 else return 0
-- ---------------------------------------------------------------

    if(exists(select supplierid from supplier where email=in_email and supplierid!=in_supplierid)) then
        select 1;
    else
        select 0;
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `checkvaliduserid` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkvaliduserid`(
in in_oauthprovider varchar(50),
in in_oauthuserid varchar(200)
)
begin
-- ----------comment---------------------------------------
-- check provider and userid already exist if exist return valid else invalid
-- --------------------------------------------------------

    if(exists(select oauthaccountid from oauthaccount where provider=in_oauthprovider and provideruserid=in_oauthuserid)) then
        select 'invalid';
    else
        select 'valid';
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitycommunitygroupbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitycommunitygroupbysupplier`(
in in_supplierid int
)
BEGIN
-- ------------Comment----------------------------------------------
-- Get Supplier community & Community group
-- ?Need to clarify whether to show balance credit amount or total amount (Right now sum of all transaction with positive values included)
-- Assumption by anna : term credit was considered as amount topup by the supplier for the community. Need to cross check with client and include the following join condition -- and st.customerid is null 

-- ?Do we need exact past month statistics or last 30 days statistics
-- -----------------------------------------------------------------

-- List of community the supplier have membership
        select c.communityid,c.name,coalesce(sum(amount),0) as credit,c.currencyid,cu.isocode as currencyname,c.active
        from communitysupplier cs inner join community c on c.communityid=cs.communityid -- and c.active  = 1
		inner join currency cu on c.currencyid=cu.currencyid
        left join suppliercommunitytransactionhistory st on st.supplierid=cs.supplierid and st.communityid=c.communityid and amount>0	 and st.customerid is null 	
		where cs.supplierid = in_supplierid and cs.isactive=1
        group by c.communityid;

-- List of community group the supplier have active membership
        select cg.communityid,cg.communitygroupid,cg.name,cg.active 
			,coalesce((select avg(rating)  from review where communitygroupid=cg.communitygroupid and supplierid=in_supplierid   ),0) as avgrating 
			,coalesce((select count(reviewid) from review where communitygroupid=cg.communitygroupid  and supplierid=in_supplierid  ),0) as reviewcount
            ,coalesce((select count(r.reviewid) from review r left join reviewresponse rs on r.reviewid=rs.reviewid 
                        where rs.reviewid is null and communitygroupid=cgs.communitygroupid and supplierid = in_supplierid ),0) as responsependingcount

        from  communitygroupsupplier cgs inner join communitygroup cg on cgs.communitygroupid=cg.communitygroupid -- and cg.active = 1 Discard Community/Community group Active/Inactive
			inner join communitysupplier cs on cs.communityid=cgs.communityid -- and cg.active = 1 
        where cgs.supplierid=in_supplierid and cgs.isactive=1 and cs.isactive=1 group by cg.communitygroupid;
        
        -- get past month activity for supplier 
        
        select a.name,sa.communitygroupid,count(sa.actionid) as actioncount 
        from supplieraction sa inner join actions a on sa.actionid=a.actionid
			inner join communitysupplier cs on cs.communityid=sa.communityid
			inner join communitygroupsupplier cgs on cgs.communityid=cs.communityid and cgs.communitygroupid=sa.communitygroupid
        where sa.supplierid=in_supplierid and cs.isactive=1  and cgs.isactive=1
        and actiondate between CONCAT(LEFT(NOW() - INTERVAL 1 MONTH,7),'-01') and LAST_DAY(CONCAT(LEFT(NOW() - INTERVAL 1 MONTH,7),'-01'))
        
        group by sa.communitygroupid,a.actionid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitydetailbysupplierid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitydetailbysupplierid`(
in in_communityid int, 
in in_supplierid int
)
begin
-- ----------------comment----------------------------------------
-- get data for 4.2.3. community detail view
-- Revision on 14-07-2014 , Include all community groups( both active and inactive)  
-- --------------------------------------------------------------


 select c.description,
 (select count(communityid) as communitygroupcount from communitygroup where communityid = in_communityid 
-- and active = 1
) as communitygroupcount

 , (select count(communityid) as suppliercount from communitysupplier where communityid = in_communityid and isactive = 1) as suppliercount
 ,  case when s.communityid is null then 0 else 1 end as ismember  
  from community c 
 left join  communitysupplier s on s.communityid = c.communityid and s.isactive = 1 and s.supplierid = in_supplierid
  where c.communityid = in_communityid ;
  
-- ----------------comment----------------------------------------
-- get community group list for the given community
-- community group name , description , suppliercount, averagerating , myrating , reviewcount , totalincome
-- -- Amount greater than 0 are considered as income 
-- ---------------------------------------------------------------

 
select 
cg.communitygroupid , cg.name , cg.description  ,
(select count(*)  from communitygroupsupplier cgs where cg.communitygroupid = cgs.communitygroupid and cgs.isactive=1) as suppliercount,
(select avg(rating)  from review r inner join communitygroupsupplier cgss on r.CommunityGroupID=cgss.CommunityGroupID and r.SupplierID=cgss.supplierid 
		where cgss.communityid=in_communityid  and cgss.CommunityGroupID=cg.communitygroupid and cgss.isactive=1) as averagerating,
(select avg(rating)  from review r where  r.supplierid = in_supplierid  and cg.communitygroupid = r.communitygroupid  ) as myrating,
(select count(reviewid)  from review r where cg.communitygroupid = r.communitygroupid and r.supplierid = in_supplierid) as reviewcount, 
 
coalesce((select sum(amount) from communityownertransactionhistory  ct where cg.communitygroupid = ct.communitygroupid 
and amount > 0 ),0) as totalincome,cu.currencyid,cu.isocode as currencyname
  , cg.active
from communitygroup cg inner join communitygroupsupplier cgs on cg.communitygroupid=cgs.communitygroupid
inner join community c on cg.communityid=c.communityid inner join currency cu on cu.currencyid=c.currencyid
where cg.communityid = in_communityid and cgs.supplierid=in_supplierid 
-- and  cg.active = 1
 and cgs.isactive=1;

        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupbillingfeeinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupbillingfeeinsert`(
in in_triggeredeventid int,
in in_communitygroupid int,
in in_fee decimal(10,2),
in in_feecurrencyid int,
in in_billfreedays int
)
BEGIN
-- -----------------comment----------------------------------------------

-- ----------------------------------------------------------------------

        insert into communitygroupbillingfee(triggeredeventid,communitygroupid,fee,feecurrencyid,billfreedays,dateupdated)
            values(in_triggeredeventid,in_communitygroupid,in_fee,in_feecurrencyid,in_billfreedays,now());
            

		insert into suppliercommunitybillfreeoverride(communitysupplierid,communitygroupbillingfeeid,billfreestart,billfreeend,isactive,communityid,communitygroupid,supplierid)
				select  CommunitySupplierID,CommunityGroupBillingFeeID,now(),date_add(now(), INTERVAL BillFreeDays day ),1,cgs.CommunityID,cgs.CommunityGroupID,cgs.SupplierID
				 from communitygroupsupplier cgs inner join communitygroupbillingfee cgb on cgs.CommunityGroupID=cgb.CommunityGroupID
				inner join communitysupplier cs on cgs.communityid=cs.communityid and cs.SupplierID=cgs.SupplierID
				where  cgs.CommunityGroupID=in_communitygroupid 
				and communitygroupbillingfeeid not in (select communitygroupbillingfeeid from suppliercommunitybillfreeoverride where communitygroupid=in_communitygroupid);
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupbillingfeeselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupbillingfeeselect`(
in in_communitygroupid int
)
begin
-- ---------------------------------comment-------------------------------
-- get all community group billing fee by community group id
-- -----------------------------------------------------------------------
    
        select coalesce(communitygroupbillingfeeid,0) as communitygroupbillingfeeid,cg.name as communitygroupname,a.name,coalesce(cgb.fee,0) as fee,
        coalesce(billfreedays,0) as billfreedays,IsPercentFee,coalesce(te.triggeredeventid,0) as triggeredeventid
        ,coalesce(cgb.feecurrencyid,cg.currencyid) as feecurrencyid,coalesce(dateupdated,now()) as dateupdated,cg.communityid
        
        from actions a inner join triggeredevent te on te.actionid=a.actionid
        left join communitygroupbillingfee cgb on cgb.triggeredeventid=te.triggeredeventid and cgb.communitygroupid=in_communitygroupid
        left join communitygroup cg on cg.communitygroupid=cgb.communitygroupid or cg.communitygroupid=in_communitygroupid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupbillingfeeupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupbillingfeeupdate`(
in in_communitygroupbillingfeeid int,
in in_fee decimal(10,2),
in in_feecurrencyid int,

in in_billfreedays int
)
begin
-- ----comment-----------------------------------------------------
-- 1. update the given community group billing fee record with the supplied details (communitygroupbillingfee)
-- ----------------------------------------------------------------
    
    update communitygroupbillingfee set fee=in_fee,feecurrencyid=in_feecurrencyid,billfreedays=in_billfreedays
    where communitygroupbillingfeeid=in_communitygroupbillingfeeid;

	update suppliercommunitybillfreeoverride set billfreeend=date_add(billfreestart, interval in_billfreedays day) 	
	where communitygroupbillingfeeid=in_communitygroupbillingfeeid;


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupdetailbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupdetailbysupplier`(
in in_communitygroupid int,
in in_supplierid int
)
begin
-- ----------------comment------------------------------------------------
-- Revision : supplier count was taken using the suppliers active in that community group
-- -----------------------------------------------------------------------

            select  coalesce(cgs.communityid,0) as communityid,coalesce(cgs.communitygroupid,0) as communitygroupid
            ,(select count(supplierid) from communitygroupsupplier where IsActive = 1 and  communitygroupid=cgs.communitygroupid ) as suppliercount
            ,(select case when isactive then 1 else 0 end from communitygroupsupplier where supplierid=in_supplierid and communitygroupid=in_communitygroupid) as ismember 
            ,coalesce((select avg(rating) from vw_activereview where  communitygroupid=in_communitygroupid),0) as communitygrouprating
             ,coalesce((select avg(rating) from vw_activereview where  communitygroupid=in_communitygroupid and supplierid=in_supplierid),0) as supplierrating

            ,(select count(*) from
                (
                (select coalesce( avg(rating),0) as avgrating,cgs.supplierid from communitygroupsupplier cgs left join vw_activereview r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid!=in_supplierid and cgs.isactive=1 group by supplierid) as tbl
                      cross join 
                (select coalesce( avg(rating),0) as avg1 from communitygroupsupplier cgs left join vw_activereview r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid) as tbl1 on avgrating >avg1
                ) 
            ) as higherratingsupplier
            
            ,(select count(*) from
                (
                (select coalesce( avg(rating),0) as avgrating,cgs.supplierid from communitygroupsupplier cgs left join vw_activereview r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid!=in_supplierid and cgs.isactive=1 group by supplierid) as tbl
                      cross join 
                (select coalesce( avg(rating),0) as avg1 from communitygroupsupplier cgs left join vw_activereview r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid) as tbl1 on avgrating <avg1
                ) 
            ) as lowerratingsupplier
            
            ,coalesce(
            
            (select count(*) from
                (
                 (select coalesce( avg(rating),0) as avgrating,cgs.supplierid from communitygroupsupplier cgs left join vw_activereview r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid!=in_supplierid and cgs.isactive=1 group by supplierid) as tbl
                      cross join 
                (select coalesce( avg(rating),0) as avg1 from communitygroupsupplier cgs left join vw_activereview r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid) as tbl1 on avgrating =avg1
                ) 
            
            ),0) as equalratingsupplier
            from communitygroupsupplier cgs 
            where  cgs.communitygroupid=in_communitygroupid and  cgs.IsActive = 1 group by cgs.communitygroupid;

            
            select s.SupplierID
			,coalesce((select avg(rating) from vw_activereview where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as suppliercommunitygrouprating 
			,companyname as suppliername,longitude,latitude,description
            ,coalesce((select count(supplierid) from vw_activereview where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as reviewcount 

            from supplier s left join vw_activereview r on r.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on s.supplierid=cgs.SupplierID left join community c on cgs.communityid=c.communityid
            where cgs.communitygroupid=in_communitygroupid and cgs.IsActive = 1 group by s.supplierid;
            
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupdetailbysupplier1` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupdetailbysupplier1`(
in in_communitygroupid int,
in in_supplierid int
)
begin
-- ----------------comment------------------------------------------------

-- -----------------------------------------------------------------------

            select  coalesce(cgs.communityid,0) as communityid,coalesce(cgs.communitygroupid,0) as communitygroupid
            ,(select count(supplierid) from communitygroupsupplier where communitygroupid=cgs.communitygroupid) as suppliercount
            ,(select case when isactive then 1 else 0 end from communitygroupsupplier where supplierid=in_supplierid and communitygroupid=cgs.communitygroupid) as ismember 
            ,coalesce(sum(r.rating)/count(r.supplierid),0) as communitygrouprating
            
            ,(select count(r1.supplierid) from review r1 where communitygroupid=r.communitygroupid 
      and rating=(select max(rating) from review r1 where  communitygroupid=r.communitygroupid)) as higherratingsupplier
            
            ,(select count(r1.supplierid)  from review r1 where communitygroupid=r.communitygroupid 
       and rating=(select min(rating) from review where  communitygroupid=r.communitygroupid)) as lowerratingsupplier
            
            ,coalesce(
            
            (
            select count(*) from 
                (select r1.supplierid from review r1 inner join review r2 on r1.rating=r2.rating 
                and r1.communitygroupid=r2.communitygroupid  and r1.supplierid!=r2.supplierid
                where  r1.communitygroupid=in_communitygroupid group by r1.supplierid) as tbl
            ),0) as equalratingsupplier
            from communitygroupsupplier cgs, review r 
            where r.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid and cgs.communitygroupid=in_communitygroupid;

            
            select r.supplierid,sum(rating)/count(r.supplierid) as suppliercommunitygrouprating ,companyname as suppliername,longitude,latitude,description
            ,(select count(supplierid) from review where communitygroupid=r.communitygroupid and supplierid=r.supplierid group by supplierid) as reviewcount 
            from supplier s inner join review r on r.supplierid=s.supplierid 
            inner join communitygroupsupplier cgs on r.communitygroupid=cgs.communitygroupid inner join community c on cgs.communityid=c.communityid
            where cgs.communitygroupid=in_communitygroupid group by r.supplierid;
            
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupinsert`(
in in_communityid int,
in in_name varchar(50),
in in_description varchar(200),
in in_creditmin decimal(10,2),
in in_currencyid int,
in in_active bit
)
begin
-- -------comment------------------------
-- 1. insert a new community group for the given community with the supplied details (communitygroup)
-- --------------------------------------
        
        insert into communitygroup (communityid,name,description,creditmin,currencyid,active)
          values (in_communityid,in_name,in_description,in_creditmin,in_currencyid,in_active);
          
        select last_insert_id();

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupjoin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupjoin`(
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int
)
begin
-- ------------comment---------------------------------------
-- 1. link the given supplier with the given community group (communitygroupsupplier) and set the datejoined to 'now' and the isactive flag to true
-- ----------------------------------------------------------

    if(exists(select communitygroupsupplierid from communitygroupsupplier where supplierid = in_supplierid and communityid = in_communityid and communitygroupid = in_communitygroupid)) then
        update communitygroupsupplier set isactive = 1, datejoined = now() where supplierid = in_supplierid and communityid = in_communityid and communitygroupid = in_communitygroupid;
    else
        insert into communitygroupsupplier (supplierid,communityid,communitygroupid,datejoined,isactive)
        values (in_supplierid,in_communityid,in_communitygroupid,now(),true);
		
			insert into suppliercommunitybillfreeoverride(communitysupplierid,communitygroupbillingfeeid,billfreestart,billfreeend,isactive,communityid,communitygroupid,supplierid)
				select  CommunitySupplierID,CommunityGroupBillingFeeID,now(),date_add(now(), INTERVAL BillFreeDays day ),1,cgs.CommunityID,cgs.CommunityGroupID,cgs.SupplierID
				 from communitygroupsupplier cgs inner join communitygroupbillingfee cgb on cgs.CommunityGroupID=cgb.CommunityGroupID
				inner join communitysupplier cs on cgs.communityid=cs.communityid and cs.SupplierID=cgs.SupplierID
				where cgs.SupplierID=in_supplierid and cgs.CommunityGroupID=in_communitygroupid;
		
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupleave` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupleave`(
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int
)
begin
-- -------------comment----------------------------------------
-- 1. find the relevant communitygroupsupplier.communitygroupsupplierid from the supplied supplierid, communityid and communitygroupid
-- 2. deactivate (communitygroupsupplier.isactive = false) the relationship between the supplied supplier - community - community group (communitygroupsupplier)
-- ------------------------------------------------------------

        update communitygroupsupplier set isactive=false 
        where supplierid=in_supplierid and communityid=in_communityid and communitygroupid=in_communitygroupid;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygrouplistactivebysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygrouplistactivebysupplier`(in in_supplierid int)
begin
-- --------------comment-------------------------------------------
-- get the community - community group that the supplier is associated with.
-- ----------------------------------------------------------------

select c.name as communityname , cg.name as communitygroupname , cg.communitygroupid  from community c 
inner join communitygroup cg on c.communityid = cg.communityid 
inner join communitygroupsupplier cgs on cg.communitygroupid = cgs.communitygroupid 
 where cgs.supplierid = in_supplierid and cgs.isactive = 1;-- and c.active = 1 and cg.active = 1

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupreviewbysupplierrating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupreviewbysupplierrating`(
in in_communitygroupid int,
in in_supplierid int,
in in_mode varchar(50)
)
begin

-- --------comment----------------------------------------------------

-- -------------------------------------------------------------------
        
        if(in_mode='high') then
 
            select s.SupplierID
			,coalesce((select avg(rating) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as suppliercommunitygrouprating 
			,companyname as suppliername,longitude,latitude,description
            ,coalesce((select count(supplierid) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as reviewcount 

            from supplier s left join review r on r.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on s.supplierid=cgs.SupplierID left join community c on cgs.communityid=c.communityid
            where cgs.communitygroupid=in_communitygroupid and cgs.IsActive = 1
            and  s.supplierid in(select supplierid from
                (
                      (select coalesce( avg(rating),0) as avgrating,cgs.supplierid from communitygroupsupplier cgs left join review r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid!=in_supplierid group by supplierid) as tbl
                      cross join 
                (select coalesce( avg(rating),0) as avg1 from communitygroupsupplier cgs left join review r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid) as tbl1 on avgrating >avg1
                ) 
            )
            group by s.supplierid;
        
        elseif(in_mode='low') then
         
            select s.SupplierID
			,coalesce((select avg(rating) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as suppliercommunitygrouprating 
			,companyname as suppliername,longitude,latitude,description
            ,coalesce((select count(supplierid) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as reviewcount 

            from supplier s left join review r on r.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on s.supplierid=cgs.SupplierID left join community c on cgs.communityid=c.communityid
            where cgs.communitygroupid=in_communitygroupid and cgs.IsActive = 1
            and  s.supplierid in(select supplierid from
                (
                     (select coalesce(avg(rating),0) as avgrating,cgs.supplierid from communitygroupsupplier cgs left join review r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid!=in_supplierid group by cgs.supplierid) as tbl
                      cross join 
                (select coalesce( avg(rating),0) as avg1 from communitygroupsupplier cgs left join review r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid) as tbl1 on avgrating <avg1
                ) 
            )
            group by s.supplierid;
            
        elseif(in_mode='equal') then
         
            select s.SupplierID
			,coalesce((select avg(rating) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as suppliercommunitygrouprating 
			,companyname as suppliername,longitude,latitude,description
            ,coalesce((select count(supplierid) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as reviewcount 
           
			from supplier s left join review r on r.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on s.supplierid=cgs.SupplierID left join community c on cgs.communityid=c.communityid
            where cgs.communitygroupid=in_communitygroupid and cgs.IsActive = 1
            and ( s.supplierid in(select supplierid from
                (
                   (select coalesce( avg(rating),0) as avgrating,cgs.supplierid from communitygroupsupplier cgs left join review r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid!=in_supplierid group by supplierid) as tbl
                      cross join 
                (select coalesce( avg(rating),0) as avg1 from communitygroupsupplier cgs left join review r1 on cgs.communitygroupid=r1.communitygroupid and cgs.supplierid=r1.supplierid
				where cgs.communitygroupid=in_communitygroupid and cgs.supplierid=in_supplierid) as tbl1 on avgrating =avg1
                ) 
            ) )
			
            group by r.supplierid;  
        
         elseif(in_mode='none') then
         
          select s.SupplierID
,coalesce((select avg(rating) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as suppliercommunitygrouprating 
,companyname as suppliername,longitude,latitude,description
            ,coalesce((select count(supplierid) from review where communitygroupid=cgs.communitygroupid and supplierid=s.supplierid group by supplierid),0) as reviewcount 

            from supplier s left join review r on r.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on s.supplierid=cgs.SupplierID left join community c on cgs.communityid=c.communityid
            where cgs.communitygroupid=in_communitygroupid and cgs.IsActive = 1
            group by s.supplierid;
        end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygrouprewardinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygrouprewardinsert`(
in in_communitygroupid int,
in in_triggeredeventid int,
in in_points int
)
BEGIN
-- -----------------------Comment--------------------------------------
-- Insert Community Group Reward point
-- --------------------------------------------------------------------

    insert into communitygroupreward(communitygroupid,triggeredeventsid,points)
    values(in_communitygroupid,in_triggeredeventid,in_points);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygrouprewardselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygrouprewardselect`(
in in_communitygroupid int
)
BEGIN
-- -------------Comment----------------------------------------------
-- Get Community group reward points
-- ------------------------------------------------------------------

        
        select coalesce(communitygrouprewardid,0) as communitygrouprewardid,cg.name as communitygroupname,a.name as actionname,coalesce(points,0) as points,
            coalesce(te.triggeredeventid,0) as triggeredeventid,cg.communityid
        
        from actions a inner join triggeredevent te on te.actionid=a.actionid
        left join communitygroupreward cgb on cgb.triggeredeventsid=te.triggeredeventid and cgb.communitygroupid=in_communitygroupid
        left join communitygroup cg on cg.communitygroupid=cgb.communitygroupid or cg.communitygroupid=in_communitygroupid;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygrouprewardupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygrouprewardupdate`(
in in_communitygrouprewardid int,
in in_points int
)
BEGIN
-- --------------Comment-------------------------------------------
-- Update Community Group Reward Point
-- ----------------------------------------------------------------

    update communitygroupreward set points=in_points where communitygrouprewardid=in_communitygrouprewardid;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupsearch` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupsearch`(
in in_searchterm varchar(50),
in in_communityid varchar(50)
)
begin
-- -----------comment--------------------------
-- 1. if the searchterm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--    use the supplied search term to search across communitygroup.name and communitygroup.description
-- 2. if a communityid is not null, then retrieve all community groups associated to the given community (communitygroup.communityid)
-- 3. return the results
-- --------------------------------------------

    select sql_no_cache communitygroupid,communityid,name,description,creditmin,currencyid,active from communitygroup
     where (name like concat('%',in_searchterm,'%') or description like concat('%',in_searchterm,'%') ) 
            and (communityid=in_communityid or in_communityid='');

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupsearchbydistance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupsearchbydistance`(
in in_searchterm varchar(50),
in in_searchdistance decimal(10,2),
in in_referencelongitude decimal(10,2),
in in_referencelatitude decimal(10,2),
in in_communityid varchar(50)
)
begin
-- -----------comment--------------------------
-- 1. if the searchterm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--    use the supplied search term to search across communitygroup.name and communitygroup.description
-- 2. if a communityid is not null, then retrieve all community groups associated to the given community (communitygroup.communityid)
-- 2. if in_searchdistance greater than 0 , then retrieve all community groups associated to the community which is within the given distance
-- 4. return the results
-- --------------------------------------------

    select sql_no_cache cg.communitygroupid,cg.communityid,cg.name,cg.description,cg.creditmin,cg.currencyid,cg.active,c.name as communityname
		from communitygroup cg
    inner join community c on cg.communityid = c.communityid 
     where (cg.name like concat('%',in_searchterm,'%') or cg.description like concat('%',in_searchterm,'%') ) 
            and ( cg.communityid= in_communityid or in_communityid='0')
            and(in_searchdistance=0 or (
            ((acos(sin(in_referencelatitude * pi() / 180) * sin(centrelatitude * pi() / 180) + cos(in_referencelatitude * pi() / 180) 
            * cos(centrelatitude * pi() / 180) * cos((in_referencelongitude - centrelongitude) * pi() / 180)) * 180 / pi()) * 60 * 1.1515)
            <=in_searchdistance
            )
            ); 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupselect`(
in in_communitygroupid int
)
begin
-- -------comment----------------------------------------------
-- 1. retrieve the community group record associated to the given communitygroupid (communitygroup.communitygroupid)
-- 2. return the results
-- ------------------------------------------------------------

        select sql_no_cache communitygroupid,cg.communityid,cg.name,cg.description,cg.creditmin,cg.currencyid,cg.active,c.name as communityname ,cu.isocode as currencyname
		from communitygroup cg inner join community c on cg.communityid=c.communityid inner join currency cu on cu.currencyid=c.currencyid
            where communitygroupid = in_communitygroupid limit 1;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupselectbycommunity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupselectbycommunity`(
in in_communityid int
)
begin
-- ------------------comment---------------------------------------------
-- get list of community group by commnity id
-- ----------------------------------------------------------------------

    select communitygroupid,c.communityid,cg.name,concat(c.name,' - ',cg.name) as communitycommunitygroupname
		from communitygroup cg inner join community c on cg.communityid=c.communityid where cg.communityid=in_communityid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupsummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupsummary`(
in in_communitygroupid int
)
begin
-- --------------comment---------------------------------------
-- Revision : changed getting customer count from supplier transaction table

-- ------------------------------------------------------------
    
         drop table if exists tmp;
         drop table if exists tmp_tc;
         
         create temporary table tmp
         (
            communitygroupid int,communitygroupname varchar(150),currencyid int,currencyname varchar(50)
            ,increditcount int
            ,outcreditcount int,belowmincreditcount int
            ,customercount int, currentrevenue decimal(10,2)
         );
         
         insert into tmp(communitygroupid,communitygroupname,currencyid,currencyname,currentrevenue)
         select sql_no_cache communitygroupid,cg.name,cu.currencyid,cu.isocode as currencyname,0
         from  communitygroup cg inner join community c on c.communityid=cg.communityid inner join currency cu on cu.currencyid=c.currencyid 
         where communitygroupid=in_communitygroupid ;
         


-- Notes by anna, even though we querying the information for a community group, the balance should be calculated by community (not by group)
         create temporary table tmp_tc as (
             select sql_no_cache cgs.communitygroupid,cgs.supplierid,cg.creditmin as mincredit, 

 
          coalesce(  
(select balance from 
vw_suppliercommunitybalance where communityid = cg.communityid and supplierid = cgs.supplierid  ),0) as balance
              
          /*
          coalesce(   (select  coalesce(balance,0) from suppliercommunitytransactionhistory where cgs.supplierid=supplierid 
             and communitygroupid=cgs.communitygroupid and suppliercommunitytransactionhistoryid= 
             (select  max(suppliercommunitytransactionhistoryid) from suppliercommunitytransactionhistory where cgs.supplierid=supplierid and communityid=cgs.communityid
              )),0) as balance
         */     
             from communitygroup cg join communitygroupsupplier cgs on cg.communitygroupid=cgs.communitygroupid where       cgs.Isactive = 1  and cgs.communitygroupid =in_communitygroupid
         );

         
         update tmp t  
         set t.increditcount=(select count(supplierid) from tmp_tc where balance>mincredit and balance>0 and communitygroupid=t.communitygroupid);
         
         update tmp t 
         set t.belowmincreditcount=(select count(supplierid) from tmp_tc where balance<=mincredit and balance>0 and communitygroupid=t.communitygroupid) ;
         
         update tmp t  
         set t.outcreditcount=(select count(supplierid) from tmp_tc where balance<=0 and communitygroupid=t.communitygroupid) ;
         
         update tmp t 
         set customercount=(select count(customerid) from customercommunity where communitygroupid=t.communitygroupid);


         update tmp t   set customercount= (select count(distinct customerid) from  suppliertransactions 
where  communitygroupid = t.communitygroupid ) ;
         
         update tmp t 
         set currentrevenue=(select coalesce(sum(amount),0) from communityownertransactionhistory where communitygroupid=t.communitygroupid and amount>0 );
         
         select sql_no_cache * from tmp;
        -- select * from tmp_tc;
        
         drop table if exists tmp;
         drop table if exists tmp_tc;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupsummarybycommunity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitygroupsummarybycommunity`(
in in_communityid int,
in in_communitygroupactive bit
)
begin
-- -----------comment-----------------------------------------------------
-- Used in OwnerCommunityDetail.aspx , to show the list of community group with number of supplier , customer and revenue in each group
-- Revision : Load only the 
-- -----------------------------------------------------------------------

         drop table if exists tmp;
         drop table if exists tmp_tc;
         -- create a temporary table structure for the desired output
         create temporary table tmp
         (
            communitygroupid int,communitygroupname varchar(150),currencyid int,currencyname varchar(50)
            ,increditcount int
            ,outcreditcount int,belowmincreditcount int
            ,customercount int, currentrevenue decimal(10,2)
         );
         
         insert into tmp(communitygroupid,communitygroupname,currencyid,currencyname,customercount,currentrevenue)
         select sql_no_cache cg.communitygroupid,cg.name,cu.currencyid,cu.isocode as currencyname,0,0
         from  communitygroup cg inner join community c on c.communityid=cg.communityid inner join currency cu on cu.currencyid=c.currencyid 
         where c.communityid=in_communityid and cg.active = in_communitygroupactive;-- and c.active = 1
         
         create temporary table tmp_tc as (
             select sql_no_cache cgs.communitygroupid,cgs.supplierid,cg.creditmin as mincredit, 

-- Notes by anna, even though we querying the information for a community group, the balance should be calculated by community (not by group)
coalesce(
 (select  coalesce(balance,0) from suppliercommunitytransactionhistory where cgs.supplierid=supplierid and communityid=cgs.communityid and SupplierCommunityTransactionHistoryID= 
					 (select  max(SupplierCommunityTransactionHistoryID) from suppliercommunitytransactionhistory where cgs.supplierid=supplierid and communityid=cgs.communityid 
					  )) ,0)  as balance 
             from communitygroup cg join communitygroupsupplier cgs on cg.communitygroupid=cgs.communitygroupid where   cgs.Isactive = 1  and cgs.communityid =in_communityid
         );

        

         update tmp t  
         set t.increditcount=(select count(supplierid) from tmp_tc where balance>mincredit and balance>0 and communitygroupid=t.communitygroupid);
         
         update tmp t 
         set t.belowmincreditcount=(select count(supplierid) from tmp_tc where balance<=mincredit and balance>0 and communitygroupid=t.communitygroupid) ;
         
         update tmp t  
         set t.outcreditcount=(select count(supplierid) from tmp_tc where balance<=0 and communitygroupid=t.communitygroupid) ;
         
/*
         update tmp t inner join suppliertransactions st  on  t.communitygroupid=st.communitygroupid
         set customercount=(select count(*) from (select count(customerid),communitygroupid from  suppliertransactions  group by customerid,communitygroupid) 
			as tbl where communitygroupid=st.communitygroupid);
  */ 

         update tmp t   set customercount= (select count(distinct customerid) from  suppliertransactions 
where  communitygroupid = t.communitygroupid ) ;

         update tmp t  
         set currentrevenue=(select coalesce(sum(amount),0) from communityownertransactionhistory where communitygroupid=t.communitygroupid and amount > 0 group by communitygroupid);
         
         select sql_no_cache communitygroupid,communitygroupname,currencyid,currencyname,customercount
		,increditcount,belowmincreditcount,outcreditcount,coalesce(currentrevenue,0) as currentrevenue from tmp order by communitygroupname;
        -- select * from tmp_tc;
        
         drop table if exists tmp;
         drop table if exists tmp_tc;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitygroupupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitygroupupdate`(
in in_communitygroupid int,
in in_name varchar(50),
in in_description varchar(200),
in in_creditmin decimal(10,2),
in in_currencyid int,
in in_active bit
)
begin
-- ---------comment------------------------------------------
-- 1. update the existing community group record with the supplied details (communitygroup)
-- ----------------------------------------------------------

        update communitygroup set name=in_name,description=in_description,creditmin=in_creditmin,currencyid=in_currencyid,active=in_active
           where communitygroupid=in_communitygroupid;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communityinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communityinsert`(
in in_name varchar(50),
in in_description varchar(200),
in in_currencyid int,
in in_countryid int,
in in_ownerid int,
in in_centrelongitude decimal(10,4),
in in_centrelatitude decimal(10,4),
in in_arearadius decimal(10,3),
in in_autotransferamtowner decimal(10,2),
in in_active bit, 
in in_countryname varchar(100)
)
begin
-- ---------------comment---------------------------------
-- 1. insert a new community record with the supplied details (community)
-- -------------------------------------------------------

declare v_countryid int;
set v_countryid=in_countryid;
		 

		if(v_countryid<= 0 and in_countryname <> '') then
 			select coalesce(countryid,0) into v_countryid from country where countryname=in_countryname;
 			if(v_countryid<= 0) then
				insert into country(countryname) values(in_countryname);
				set v_countryid=(select last_insert_id());
			end if;
		end if;
       insert into community (name,description,currencyid,countryid,ownerid,centrelongitude,centrelatitude,arearadius,autotransferamtowner,active)
            values (in_name,in_description,in_currencyid,v_countryid,in_ownerid,in_centrelongitude,in_centrelatitude,in_arearadius,in_autotransferamtowner,in_active);
            
        select last_insert_id();
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityjoin` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communityjoin`(
in in_supplierid int,
in in_communityid int,
in in_autotransferamtsupplier decimal(10,2),
in in_autotopup bit,
in in_mincredit decimal(10,2)
)
begin
-- -------comment--------------------------------------------
-- 1. link the given supplier with the given community (communitysupplier) and set the datejoined to 'now' and the isactive flag to true
-- ----------------------------------------------------------

    if(exists(select communitysupplierid from communitysupplier where supplierid = in_supplierid and communityid = in_communityid)) then
        update communitysupplier set isactive = 1, datejoined = now() where supplierid = in_supplierid and communityid = in_communityid;
    else
        insert into communitysupplier(supplierid,communityid,datejoined,isactive,autotransferamtsupplier,autotopup,mincredit)
        values(in_supplierid,in_communityid,now(),true,in_autotransferamtsupplier,in_autotopup,in_mincredit);
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communityleave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communityleave`(
in in_id int,
in in_entity varchar(50),
in in_communityid int
)
begin
-- ------------comment------------------------------------
-- 1. find the relevant communitysupplier.communitysupplierid from the supplied supplierid and communityid
-- 2. deactivate (communitysupplier.isactive = false) the relationship between the supplied supplier - community (communitysupplier)
-- 3. deactivate (communitygroupsupplier.isactive = false) the relationship between the supplied supplier - community  (communitygroupsupplier)
-- -------------------------------------------------------

    if(in_entity='supplier') then
    
        update communitysupplier set isactive=false where supplierid=in_id and communityid=in_communityid;
		
		update communitygroupsupplier set isactive=false where supplierid=in_id and communityid=in_communityid;

    elseif(in_entity='customer') then
        
        update customercommunity set isactive=false where customerid=in_id and communityid=in_communityid;
        
    end if;
    

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitylistactivebysupplier` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitylistactivebysupplier`(
in in_supplierid int
)
begin
-- --------------comment-------------------------------------------

-- ----------------------------------------------------------------
     select cs.communityid , name from community c inner join communitysupplier cs on cs.communityid=c.communityid 
     where  supplierid = in_supplierid  ;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communitylistbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitylistbysupplier`(
in in_supplierid int,
in in_isactive int
)
begin
-- ----------------comment---------------------------
-- retreives list of communities, active and inactive counts from each community and their total for a particular supplier.
-- TODO : Need to check is there any possibility to optimize the procedure
-- --------------------------------------------------

Select c.name , c.communityid , 
-- Get count of active groups in which the supplier belongs to 
(
select count(cgs.communityid) as active from communitygroupsupplier  cgs
inner join communitygroup cg on cgs.communitygroupid = cg.communitygroupid and cg.active = 1 
where cs.communityid = cgs.communityid and cgs.supplierid = cs.supplierid and cgs.isactive = 1
) as active,
-- Get count of in active groups in which the supplier belongs to 
(
select count(cgs.communityid) as inactive from communitygroupsupplier  cgs
inner join communitygroup cg on cgs.communitygroupid = cg.communitygroupid and cg.active = 0 
where cs.communityid = cgs.communityid and cgs.supplierid = cs.supplierid and cgs.isactive = 1 
) as inactive,
 -- Count of both active and inactive groups 
(
select count(cgs.communityid) as inactive from communitygroupsupplier  cgs
inner join communitygroup cg on cgs.communitygroupid = cg.communitygroupid  
where cs.communityid = cgs.communityid and cgs.supplierid = cs.supplierid and cgs.isactive = 1 
) as total
 from communitysupplier cs
inner join community c on cs.communityid = c.communityid and c.active = in_isactive
where cs.supplierid = in_supplierid and cs.isactive = 1 ;
/*
    select name,cs.communityid,
        (select count(communityid) as active from communitygroupsupplier where cs.communityid = communityid and supplierid = cs.supplierid and isactive = 1) as active,
        (select count(communityid) as active from communitygroupsupplier where cs.communityid = communityid and supplierid = cs.supplierid and isactive = 0) as inactive,
        (select count(communityid) as active from communitygroup  where communityid = cs.communityid ) as total
    from communitysupplier cs inner join community c on c.communityid = cs.communityid where supplierid = in_supplierid and cs.isactive = in_isactive;
*/
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityownertransactionselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communityownertransactionselect`(
in in_ownerid int,
in in_communityid int,
in in_communitygroupid int,
in in_fromdate date,
in in_todate date,
in in_rowindex int,
in in_rowcount int
)
BEGIN

-- --------------------------comment----------------------------------------
-- Revision made to include all record for exporting if rowcount and rowindex equals 0
-- -------------------------------------------------------------------------
if(in_rowindex = 0 and in_rowcount = 0) then
begin
 
     select SQL_CALC_FOUND_ROWS ct.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
         ,coalesce(cu.firstname,'n/a') as customername,ct.dateapplied,ct.amount,coalesce(s.companyname,'n/a') as suppliername,cur.currencyid,cur.isocode as currencyname
	 from communityownertransactionhistory ct inner join community c on ct.communityid=c.communityid
			inner join currency cur on cur.currencyid=c.currencyid
            left join communitygroup cg on ct.communitygroupid=cg.communitygroupid 
            left join billingreference b on b.communityownertransactionhistoryid=ct.communityownertransactionhistoryid
            left join suppliercommunitytransactionhistory st on st.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid
            left join supplier s on st.supplierid=s.supplierid
            left join customer cu on st.customerid=cu.customerid
        where ct.ownerid=in_ownerid and (ct.communityid=in_communityid or in_communityid=0)
            and (ct.communitygroupid=in_communitygroupid or in_communitygroupid=0) 
            and ( date(ct.dateapplied)>= date(in_fromdate) or in_fromdate is null) 
			and (date(ct.dateapplied)<=date(in_todate) or in_todate is null)
        order by ct.dateapplied desc;

end;
else
begin
 
     select SQL_CALC_FOUND_ROWS ct.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
         ,coalesce(cu.firstname,'n/a') as customername,ct.dateapplied,ct.amount,coalesce(s.companyname,'n/a') as suppliername,cur.currencyid,cur.isocode as currencyname
	 from communityownertransactionhistory ct inner join community c on ct.communityid=c.communityid
			inner join currency cur on cur.currencyid=c.currencyid
            left join communitygroup cg on ct.communitygroupid=cg.communitygroupid 
            left join billingreference b on b.communityownertransactionhistoryid=ct.communityownertransactionhistoryid
            left join suppliercommunitytransactionhistory st on st.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid
            left join supplier s on st.supplierid=s.supplierid
            left join customer cu on st.customerid=cu.customerid
        where ct.ownerid=in_ownerid and (ct.communityid=in_communityid or in_communityid=0)
            and (ct.communitygroupid=in_communitygroupid or in_communitygroupid=0) 
            and ( date(ct.dateapplied)>= date(in_fromdate) or in_fromdate is null) 
			and (date(ct.dateapplied)<=date(in_todate) or in_todate is null)
        order by ct.dateapplied desc limit in_rowindex,in_rowcount;

end;

end if;
 
	SELECT FOUND_ROWS() as totalrecords;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitysearch` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communitysearch`(
in in_searchterm varchar(50),
in in_searchdistance decimal(10,2),
in in_referencelongitude decimal(10,2),
in in_referencelatitude decimal(10,2)
)
begin
-- ------------------comment----------------------------------------
-- 1. if the searchterm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--     use the supplied search term to search across community.name and community.description)
-- 2. if searchdistance is not null, using the referencelongitude, referencelatitude & searchdistance, retrieve communities that have a 
--      community.centrelongitude and community.centrelatitude point no further away than the supplied searchdistance.
-- 3. return the results
-- http://zcentric.com/2010/03/11/calculate-distance-in-mysql-with-latitude-and-longitude/
-- -----------------------------------------------------------------

        select communityid,name,description,currencyid,countryid,ownerid,centrelongitude,centrelatitude,arearadius,autotransferamtowner,active
         from community where (name like concat('%',in_searchterm,'%') or description like concat('%',in_searchterm,'%')) 
            and(in_searchdistance=0 or (
            ((acos(sin(in_referencelatitude * pi() / 180) * sin(centrelatitude * pi() / 180) + cos(in_referencelatitude * pi() / 180) 
            * cos(centrelatitude * pi() / 180) * cos((in_referencelongitude - centrelongitude) * pi() / 180)) * 180 / pi()) * 60 * 1.1515)
            <=in_searchdistance
            )
            );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communityselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communityselect`(
in in_communityid int
)
begin
-- ----------comment------------------------------------
-- 1. retrieve the community record associated to the given communityid (community.communityid)
-- 2. return the results
-- -----------------------------------------------------

    select sql_no_cache communityid,name,c.description,cu.currencyid,countryid,ownerid, centrelongitude,centrelatitude,arearadius,autotransferamtowner,active
	,isocode as currencyname,cu.mintransferamount
      from community c inner join currency cu on cu.currencyid=c.currencyid where communityid=in_communityid limit 1;
      
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityselectall` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communityselectall`()
BEGIN
-- -------------comment---------------------------------------
-- Get all community
-- -----------------------------------------------------------

        select communityid,name,description,currencyid,countryid,ownerid,active from community;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communityselectbycurrency` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communityselectbycurrency`(
in in_currencyid int
)
BEGIN
-- -----------------------comment------------------
-- get community by currency
-- ------------------------------------------------

			select communityid,name,description,currencyid,countryid,ownerid,active from community where currencyid=in_currencyid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityselectbyidandowner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communityselectbyidandowner`(
in in_ownerid int,
in in_communityid int
)
BEGIN
-- ----------------comment------------------------------------------
-- Recreated from communityselect procedure
-- ------------------------------------------------------------------
		select sql_no_cache communityid,name,c.description,cu.currencyid,countryid,ownerid, centrelongitude,centrelatitude,arearadius,autotransferamtowner,active
			,isocode as currencyname,cu.mintransferamount
		from community c inner join currency cu on cu.currencyid=c.currencyid where communityid=in_communityid and ownerid=in_ownerid limit 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityselectbyowner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communityselectbyowner`(
in in_ownerid int
)
begin
-- --------------comment---------------------------------------
-- get list of community by owner id
-- ------------------------------------------------------------

        select communityid,name from community where ownerid=in_ownerid order by name;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityselectbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communityselectbysupplier`(
in in_supplierid int
)
BEGIN
-- -----------------comment---------------------------------------
-- Get Community related to supplier (CommunitySupplier)
-- ----------------------------------------------------------------

        select c.communityid,c.name from community c inner join communitysupplier cs on c.communityid=cs.communityid
        where cs.supplierid=in_supplierid AND isactive = 1;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitysummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitysummary`(
in in_communityid int
)
begin

-- ----------------comment-------------------------------------------------------------------------------------------------------
-- Revision on 24-06-2014 , by anna : 
-- Select only community and community group with value Active = 1 
-- A supplier can be in both “In Credit” and “Below Min Credit” for a same community if there is more than one community group exist with different Min Credit. 
-- ------------------------------------------------------------------------------------------------------------------------------
         

         drop table if exists tmpcommunitylist;
         drop table if exists tmpsuppliercount;
         
         create temporary table tmpcommunitylist
         (
            communityid int,communityname varchar(150),currencyid int,currencyname varchar(50)
            ,communitygroupcount int,increditcount int
            ,outcreditcount int,belowmincreditcount int
            ,customercount int, currentrevenue decimal(10,2)
			, lowestmincredit  decimal(10,2), highestmincredit decimal(10,2)
         );
         
         insert into tmpcommunitylist(communityid,communityname,communitygroupcount,currencyid,currencyname,lowestmincredit,highestmincredit) 
         select sql_no_cache c.communityid,c.name,count(cg.communityid) as communitygroups,cu.currencyid,cu.isocode as currencyname ,
	coalesce( min(cg.creditmin),0) as lowestmincredit , coalesce( max(cg.creditmin),0)as highestmincredit 
			from community c 
left join communitygroup cg on c.communityid=cg.communityid -- and cg.active = 1 
inner join currency cu on cu.currencyid=c.currencyid
         where  c.communityid=in_communityid group by c.communityid;-- c.active = 1 and 
         
-- Get list of suppli
         create temporary table tmpsuppliercount as (
			select sql_no_cache c.communityid,cs.supplierid, 
					coalesce( (select  balance from suppliercommunitytransactionhistory where cs.supplierid=supplierid and communityid=cs.communityid and suppliercommunitytransactionhistoryid= 
					 (select  max(suppliercommunitytransactionhistoryid) from suppliercommunitytransactionhistory where cs.supplierid=supplierid and communityid=cs.communityid 
					  ))  ,0) as balance
			from community c 
		 left join communitysupplier cs on c.communityid=cs.communityid and cs.isactive = 1 
			where  c.communityid=in_communityid  -- c.active = 1 and
         );

        -- update tmp_tc set incredit=1 where balance>mincredit and balance!=0;
        -- update tmp_tc set belowmincredit=1 where balance<mincredit and balance!=0;
        -- update tmp_tc set outcredit=1 where balance=0;
         
-- In Credit , number of suppliers who have balance greater than the lowest minimum  credit of the community group belongs to the community  
         update tmpcommunitylist t  
         set t.increditcount=(select count(supplierid) from tmpsuppliercount where balance>lowestmincredit and balance>0 and communityid=t.communityid);
-- Below Min Credit , number of suppliers who have balance less than or equal to the highest minimum  credit of the community group belongs to the community           
         update tmpcommunitylist t 
         set t.belowmincreditcount=(select count(supplierid) from tmpsuppliercount where balance<=highestmincredit and balance>0 and communityid=t.communityid) ;
-- Out of Credit , number of suppliers who have balance less than or equal to zero  in their virtual community account
         update tmpcommunitylist t  
         set t.outcreditcount=(select count(supplierid) from tmpsuppliercount where balance<=0 and communityid=t.communityid) ;
         
         update tmpcommunitylist t 
         set customercount=(select count(customerid) from customercommunity where communityid=t.communityid);
          
         update tmpcommunitylist t 
         set currentrevenue=coalesce((select sum(amount) from communityownertransactionhistory where communityid=t.communityid and amount > 0 ),0);
         
         select sql_no_cache * from tmpcommunitylist;
        -- select * from tmp_tc;
        
         drop table if exists tmpcommunitylist;
         drop table if exists tmpsuppliercount; 
         
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitysummarybyidandowner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitysummarybyidandowner`(
in in_ownerid int,
in in_communityid int
)
BEGIN
-- -------------comment----------------------------
-- recreated from communitysummary procedure
-- ------------------------------------------------
drop table if exists tmpcommunitylist;
         drop table if exists tmpsuppliercount;
         
         create temporary table tmpcommunitylist
         (
            communityid int,communityname varchar(150),currencyid int,currencyname varchar(50)
            ,communitygroupcount int,increditcount int
            ,outcreditcount int,belowmincreditcount int
            ,customercount int, currentrevenue decimal(10,2)
			, lowestmincredit  decimal(10,2), highestmincredit decimal(10,2)
         );
         
         insert into tmpcommunitylist(communityid,communityname,communitygroupcount,currencyid,currencyname,lowestmincredit,highestmincredit) 
         select sql_no_cache c.communityid,c.name,count(cg.communityid) as communitygroups,cu.currencyid,cu.isocode as currencyname ,
			coalesce( min(cg.creditmin),0) as lowestmincredit , coalesce( max(cg.creditmin),0)as highestmincredit 
		  from community c 
			left join communitygroup cg on c.communityid=cg.communityid and cg.active = 1 
			inner join currency cu on cu.currencyid=c.currencyid
		 where c.active = 1 and  c.communityid=in_communityid and c.ownerid=in_ownerid group by c.communityid;
         
-- Get list of suppli
         create temporary table tmpsuppliercount as (
			select sql_no_cache c.communityid,cs.supplierid, 
					coalesce( (select  balance from suppliercommunitytransactionhistory where cs.supplierid=supplierid and communityid=cs.communityid and suppliercommunitytransactionhistoryid= 
					 (select  max(suppliercommunitytransactionhistoryid) from suppliercommunitytransactionhistory where cs.supplierid=supplierid and communityid=cs.communityid 
					  ))  ,0) as balance
			from community c 
		 left join communitysupplier cs on c.communityid=cs.communityid and cs.isactive = 1 
			where c.active = 1 and  c.communityid=in_communityid and c.ownerid=in_ownerid
         );

        -- update tmp_tc set incredit=1 where balance>mincredit and balance!=0;
        -- update tmp_tc set belowmincredit=1 where balance<mincredit and balance!=0;
        -- update tmp_tc set outcredit=1 where balance=0;
         
-- In Credit , number of suppliers who have balance greater than the lowest minimum  credit of the community group belongs to the community  
         update tmpcommunitylist t  
         set t.increditcount=(select count(supplierid) from tmpsuppliercount where balance>lowestmincredit and balance>0 and communityid=t.communityid);
-- Below Min Credit , number of suppliers who have balance less than or equal to the highest minimum  credit of the community group belongs to the community           
         update tmpcommunitylist t 
         set t.belowmincreditcount=(select count(supplierid) from tmpsuppliercount where balance<=highestmincredit and balance>0 and communityid=t.communityid) ;
-- Out of Credit , number of suppliers who have balance less than or equal to zero  in their virtual community account
         update tmpcommunitylist t  
         set t.outcreditcount=(select count(supplierid) from tmpsuppliercount where balance<=0 and communityid=t.communityid) ;
         
         update tmpcommunitylist t 
         set customercount=(select count(customerid) from customercommunity where communityid=t.communityid);
          
         update tmpcommunitylist t 
         set currentrevenue=coalesce((select sum(amount) from communityownertransactionhistory where communityid=t.communityid and amount > 0 ),0);
         
         select sql_no_cache * from tmpcommunitylist;
        -- select * from tmp_tc;
        
         drop table if exists tmpcommunitylist;
         drop table if exists tmpsuppliercount; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitysummarybyowner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitysummarybyowner`(
in in_ownerid int,
in in_communityactive bit
)
begin
-- ----------------comment-------------------------------------------------------------------------------------------------------
-- revision on 23-06-2014 , by anna : 
-- select only community and community group with value active = 1 
-- a supplier can be in both “in credit” and “below min credit” for a same community if there is more than one community group exist with different min credit. 
-- ------------------------------------------------------------------------------------------------------------------------------
         

         drop table if exists tmpcommunitylist;
         drop table if exists tmpsuppliercount;
         
         create temporary table tmpcommunitylist
         (
            communityid int,communityname varchar(150),currencyid int,currencyname varchar(50)
            ,communitygroupcount int,increditcount int
            ,outcreditcount int,belowmincreditcount int
            ,customercount int, currentrevenue decimal(10,2)
			, lowestmincredit  decimal(10,2), highestmincredit decimal(10,2)
         );
         
-- Get active community list of the owner and its  community group count , currency and the minimum credit of the community
         insert into tmpcommunitylist(communityid,communityname,communitygroupcount,currencyid,currencyname,lowestmincredit,highestmincredit,currentrevenue)
         select sql_no_cache c.communityid,c.name,count(cg.communityid) as communitygroups,cu.currencyid,cu.isocode as currencyname ,
			coalesce( min(cg.creditmin),0) as lowestmincredit , coalesce( max(cg.creditmin),0)as highestmincredit ,0
			from community c 
			left join communitygroup cg on c.communityid=cg.communityid 
-- and cg.active = 1 To get all communty group under this community
			inner join currency cu on cu.currencyid=c.currencyid
         where c.active = in_communityactive and ownerid=in_ownerid group by c.communityid; -- TODO: Check whether we need to group by all columns
         
-- get list of supplier , community and supplier's virtual community balance
         create temporary table tmpsuppliercount as (
			select sql_no_cache c.communityid,cs.supplierid, 
					coalesce( (select  balance from suppliercommunitytransactionhistory where cs.supplierid=supplierid and communityid=cs.communityid and SupplierCommunityTransactionHistoryID= 
					 (select  max(SupplierCommunityTransactionHistoryID) from suppliercommunitytransactionhistory where cs.supplierid=supplierid and communityid=cs.communityid 
					  )) ,0)  as balance
		from community c 
		 left join communitysupplier cs on c.communityid=cs.communityid and cs.isactive = 1 
			where c.active = in_communityactive and ownerid=in_ownerid
         );

        -- update tmp_tc set incredit=1 where balance>mincredit and balance!=0;
update tmpcommunitylist t 
set 
    t.increditcount = (select count(supplierid) from tmpsuppliercount
        where balance > lowestmincredit and balance > 0
                and communityid = t.communityid );
-- below min credit , number of suppliers who have balance less than or equal to the highest minimum  credit of the community group belongs to the community           
update tmpcommunitylist t 
set 
    t.belowmincreditcount = (select count(supplierid) from tmpsuppliercount
        where balance <= highestmincredit and balance > 0
                and communityid = t.communityid);
-- out of credit , number of suppliers who have balance less than or equal to zero  in their virtual community account
update tmpcommunitylist t 
set 
    t.outcreditcount = (select  count(supplierid) from tmpsuppliercount
        where
            balance <= 0
			  and communityid = t.communityid);
         
update tmpcommunitylist t 
set 
    customercount = (select  count(customerid) from customercommunity
        where
            communityid = t.communityid);
          
update tmpcommunitylist t 
set 
    currentrevenue = coalesce((select sum(amount)
                from communityownertransactionhistory
                where
                    communityid = t.communityid
                        and amount > 0
                group by communityid),
            0);
         
select sql_no_cache  * from tmpcommunitylist order by communityname;
        -- select * from tmp_tc;
        
         drop table if exists tmpcommunitylist;
         drop table if exists tmpsuppliercount;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communitysupplierselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communitysupplierselect`(
in in_supplierid int,
in in_communityid int
)
BEGIN
-- ----------------comment---------------------------------------
-- Get Supplier Community join detail
-- --------------------------------------------------------------

        select supplierid,communityid,datejoined,isactive,autotransferamtsupplier,autotopup,mincredit
        from communitysupplier where supplierid=in_supplierid and communityid=in_communityid and isactive=1;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `communityupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `communityupdate`(
in in_communityid int,
in in_name varchar(50),
in in_description varchar(200),
in in_currencyid int,
in in_countryid int,
in in_centrelongitude decimal(10,4),
in in_centrelatitude decimal(10,4),
in in_arearadius decimal(10,3),
in in_autotransferamtowner decimal(10,2),
in in_active bit
)
begin
-- -----------comment------------------------------------------
-- 1. update the existing community record with the supplied details (community)
-- ------------------------------------------------------------

    update community set name=in_name, description=in_description, currencyid=in_currencyid, countryid=in_countryid
        ,centrelongitude=in_centrelongitude, centrelatitude=in_centrelatitude, arearadius=in_arearadius
        ,autotransferamtowner=in_autotransferamtowner, active=in_active
    where communityid=in_communityid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `communiygroupselectbyidandowner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `communiygroupselectbyidandowner`(
in in_ownerid int,
in in_communityid int,
in in_communitygroupid int
)
BEGIN
-- ----------------comment-----------------------------
-- get communitygroup by given ownerid,communityid and groupid
-- recreated from communitygropupselect
-- ----------------------------------------------------

		 select  communitygroupid,cg.communityid,cg.name,cg.description,cg.creditmin,cg.currencyid,cg.active,c.name as communityname ,cu.isocode as currencyname
		from communitygroup cg inner join community c on cg.communityid=c.communityid inner join currency cu on cu.currencyid=c.currencyid
            where c.communityid=in_communityid and c.ownerid=in_ownerid and communitygroupid = in_communitygroupid limit 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countryselectall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countryselectall`()
begin
-- -----------------comment------------------------------
-- get all country list from country table
-- ------------------------------------------------------

    select sql_no_cache countryid,countryname from country order by countryname;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `creditvirtualcommunityaccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `creditvirtualcommunityaccount`(
in in_id int,
in in_entity varchar(50),
in in_communityid int,
in in_communitygroupid int,
in in_description varchar(200),
in in_amount decimal(10,2),
in in_dateapplied datetime, -- not in use (used now())
in in_customerid int
)
begin
-- -------comment--------------------------------------------------------
-- 1. if the supplied entity is "supplier"
--      a) retrieve the current balance for the supplier's community virtual account (suppliercommunitytransactionhistory.balance) based on the most recent transaction 
--          ( max(suppliercommunitytransactionhistory.dateapplied) ) for the given supplier-community relationship
--      b) calculate the new balance for the supplier's community virtual account from the current balance and the deposit amount 
--          (suppliercommunitytransactionhistory.balance + amount)
--      c) add a new transaction record to the supplier's community virtual account based on the calculated balance and the supplied details 
--          (suppliercommunitytransactionhistory)
-- 2. if the supplied entity is "community owner"
--      a) retrieve the current balance for the community owner's community virtual account (communityownertransactionhistory.balance) 
--          based on the most recent transaction ( max(communityownertransactionhistory.dateapplied) ) for the given community owner-community relationship
--      b) calculate the new balance for the community owner's community virtual account from the current balance and the deposit amount 
--          (communityownertransactionhistory.balance + amount)
--      c) add a new transaction record to the community owner's community virtual account based on the calculated balance and the supplied details 
--          (communityownertransactionhistory)
-- ----------------------------------------------------------------------

    declare v_balance decimal(10,2);
    set v_balance=0;
    
    if(in_entity='supplier') then
     begin
       set v_balance=coalesce( (select coalesce(balance,0) from suppliercommunitytransactionhistory where supplierid=in_id and communityid=in_communityid 
                      and SupplierCommunityTransactionHistoryID= (select max(SupplierCommunityTransactionHistoryID) from suppliercommunitytransactionhistory 
						where supplierid=in_id and communityid=in_communityid )
                    ),0);
                   
        insert into suppliercommunitytransactionhistory(supplierid,communityid,communitygroupid,description,amount,dateapplied,balance,customerid)
         values(in_id,in_communityid,in_communitygroupid,in_description,in_amount,now(),(v_balance+in_amount),in_customerid);
         
         select suppliercommunitytransactionhistoryid,supplierid,communityid,communitygroupid,description,amount,dateapplied,balance,customerid 
            from suppliercommunitytransactionhistory where suppliercommunitytransactionhistoryid=last_insert_id();
         
     end;
     
     elseif(in_entity='community owner') then
     begin
     
      set v_balance=coalesce( (select coalesce(balance,0) from communityownertransactionhistory where ownerid=in_id and communityid=in_communityid 
                      and communityownertransactionhistoryid=(select max(communityownertransactionhistoryid) from communityownertransactionhistory where ownerid=in_id and communityid=in_communityid
                                       )
                    ),0);
                    
        insert into communityownertransactionhistory(ownerid,communityid,communitygroupid,description,amount,dateapplied,balance)
         values(in_id,in_communityid,in_communitygroupid,in_description,in_amount,now(),(v_balance+in_amount));
         
         select communityownertransactionhistoryid,ownerid,communityid,communitygroupid,description,amount,dateapplied,balance
            from communityownertransactionhistory where communityownertransactionhistoryid=last_insert_id();
         
     end;

     elseif(in_entity='admin') then
     begin
     
      set v_balance=coalesce( (select coalesce(balance,0) from admintransactionhistory where  communityid=in_communityid 
                      and admintransactionhistoryid=(select max(admintransactionhistoryid) from admintransactionhistory where communityid=in_communityid
                                       )
                    ),0);
                    
        insert into admintransactionhistory(communityid,communitygroupid,description,amount,dateapplied,balance)
         values(in_communityid,in_communitygroupid,in_description,in_amount,now(),(v_balance+in_amount));
         
         select admintransactionhistoryid,communityid,communitygroupid,description,amount,dateapplied,balance
            from admintransactionhistory where admintransactionhistoryid=last_insert_id();
         
     end;
     
    end if;


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `currencyinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `currencyinsert`(
in in_isocode varchar(3),
in in_description varchar(50),
in in_mintransferamount decimal(10,2),
in in_isactive bit
)
begin
-- ----------------comment-----------------------------------
-- 1. create a new currency within the system from the supplied details (currency)
-- ----------------------------------------------------------

    insert into currency (isocode,description,mintransferamount,isactive)
        values(in_isocode,in_description,in_mintransferamount,in_isactive);
    
    select last_insert_id();
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `currencyselectactive` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `currencyselectactive`()
begin
-- ------------comment-----------------------------------------
-- get all active currency
-- ------------------------------------------------------------

    select sql_no_cache currencyid,isocode,description,mintransferamount,isactive
        from currency where isactive=true;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `currencyselectall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `currencyselectall`()
begin
-- ------------------comment-----------------------------
-- get all currency from currency
-- ------------------------------------------------------

    select sql_no_cache currencyid,isocode,description,mintransferamount,isactive
        from currency order by isocode;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `currencyselectbyowner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `currencyselectbyowner`(
in in_ownerid int
)
BEGIN
-- --------------------comment--------------
-- Get currency for give owner
-- -----------------------------------------

		select o.ownerid,o.companyname,cu.currencyid,cu.isocode as currencyname
			
		from owner o inner join community c on o.ownerid=c.ownerid 
				inner join currency cu on cu.currencyid=c.currencyid
		where o.ownerid=in_ownerid
			group by cu.currencyid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `currencyupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `currencyupdate`(
in in_currencyid int,
in in_isocode varchar(3),
in in_description varchar(50),
in in_mintransferamount decimal(10,2),
in in_isactive bit
)
begin
-- ---------------comment---------------------------------------
-- 1. update an existing currency record from the supplied currencyid (currency.currencyid) with the supplied details (currency)
-- -------------------------------------------------------------

    update currency set isocode=in_isocode, description=in_description, mintransferamount=in_mintransferamount, isactive=in_isactive
     where currencyid=in_currencyid;
     
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customeravatarinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customeravatarinsert`(
in in_customerid int,
in in_avatar binary(10)
)
begin
-- ------------comment---------------------------------------
-- insert a new customeravatar record with the supplied details (customeravatar)
-- if already exist then update avatar
-- ----------------------------------------------------------

    if(exists(select customerid from customeravatar where customerid=in_customerid)) then
        update customeravatar set avatar=in_avatar where customerid=in_customerid;
    else
        insert into customeravatar(customerid,avatar) values(in_customerid,in_avatar);
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customerinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerinsert`(
in in_email varchar(100),
in in_mobilephone varchar(50),
in in_firstname varchar(50),
in in_lastname varchar(50),
in in_handle varchar(50),
in in_gender char(10),
in in_datejoined datetime
)
begin
-- --------------comment----------------------------------
-- 1. insert  customer record with the supplied details (customer)
-- -------------------------------------------------------

    insert into customer(email,mobilephone,firstname,lastname,handle,gender,datejoined)
        values(in_email,in_mobilephone,in_firstname,in_lastname,in_handle,in_gender,in_datejoined);
    
    select last_insert_id();
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customernoteupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customernoteupdate`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_notetext text
)
begin
-- ---------------comment-------------------------------------
-- 1. check if a record already exists for the given supplier-customer-community-community group relationship in the suppliercustomernote table 
--      and retieve the suppliercustomernote.suppliercustomernoteid if it does
-- 2. if the returned suppliercustomernoteid is not null, update the existing record (suppliercustomernote.suppliercustomernoteid) with the 
--      updated customer note text (suppliercustomernote.customernote)
-- 3. if the returned suppliercustomernoteid is null, create a new record for the given supplier-customer-community-community group relationship in 
--      the suppliercustomernote table, populating the customer note field (suppliercustomernote.customernote)
-- -----------------------------------------------------------

    if exists(select suppliercustomernoteid from suppliercustomernote where customerid=in_customerid and supplierid=in_supplierid and communityid=in_communityid and communitygroupid=in_communitygroupid) then
    
        update suppliercustomernote set customernote=in_notetext where customerid=in_customerid and supplierid=in_supplierid and communityid=in_communityid and communitygroupid=in_communitygroupid;
    
    else
        
        insert into suppliercustomernote (customerid,communityid,communitygroupid,supplierid,customernote)
         values(in_customerid,in_communityid,in_communitygroupid,in_supplierid,in_notetext);
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customerquoteinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customerquoteinsert`(
in in_customerid int,
in in_communityid int,
in in_communitygroupid int,
in in_supplierid int,
-- in in_actionid int,
in  in_quoteamount decimal(15,2),
in in_depositspecified bit,
in in_depositamount decimal(15,2),
in in_quoteterms varchar(250),
in in_depositterms varchar(250),
in in_currencyid int,
in in_quotedetail varchar(200),
in in_parentsupplieractionid int

)
BEGIN
-- --------------comment---------------------------------------
-- Trigger actioninsert procedure
-- insert quote detail
-- ------------------------------------------------------------

		declare v_actionid int;
        declare  v_ownerid int;

        set v_ownerid  =(select ownerid from community where communityid =in_communityid);
		set v_actionid =(select actionid from actions where name ='Quote');


         CALL actioninsert(in_communityid, in_communitygroupid,v_actionid,v_ownerid, in_supplierid ,in_customerid, in_quotedetail, 0.00
         ,in_parentsupplieractionid,@supplieractionid);
         
         insert into customerquote(customerid,communityid,communitygroupid,supplierid,quoteamount,depositspecified,depositamount,quoteterms,depositterms
         ,currencyid,quotedetail,supplieractionid)
         values(in_customerid,in_communityid,in_communitygroupid,in_supplierid,in_quoteamount,in_depositspecified,in_depositamount,in_quoteterms
         ,in_depositterms,in_currencyid,in_quotedetail,@supplieractionid);

 
-- Get Communication details to send it as email		
		select q.customerquoteid ,
q.customerid,q.communityid,q.communitygroupid,q.supplierid,q.quoteamount,q.depositspecified,q.depositamount,q.quoteterms,q.depositterms
         ,q.currencyid,q.quotedetail,q.supplieractionid,
				c.email as customeremail , c.firstname as CustomerFirstName  , c.lastname as CustomerLastName, 
				s.email as supplieremail , s.companyname as suppliername , cg.communityname , cg.communitygroupname
, cu.isocode
				from customerquote q
				inner join customer c on c.customerid = q.customerid
				inner join supplier s on s.supplierid = q.supplierid
				inner join vw_communitygroup cg on cg.communitygroupid = q.communitygroupid  
inner join currency cu on cu.currencyid = q.currencyid
				where customerquoteid = last_insert_id();
         
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customerquoteselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customerquoteselect`(
in in_quoteid int
)
BEGIN
-- ------------comment-------------------------------
-- Get customer quote information
-- --------------------------------------------------

			select customerquoteid,customerid,communityid,communitygroupid,supplierid,quoteamount,depositspecified
				,depositamount,quoteterms,depositterms,currencyid,quotedetail,supplieractionid
			from customerquote where customerquoteid=in_quoteid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customerquoteselectbyparentsupplieractionid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customerquoteselectbyparentsupplieractionid`(
in in_parentsupplieractionid int
)
BEGIN

		declare v_actionid int;
		set v_actionid =(select actionid from actions where name ='Quote');

		select customerquoteid,customerid,communityid,communitygroupid,supplierid,quoteamount,depositspecified
				,depositamount,quoteterms,depositterms,currencyid,quotedetail,supplieractionid
			from customerquote where SupplierActionID=(select SupplierActionID from supplieraction where ParentSupplierActionId=in_parentsupplieractionid and actionid=v_actionid);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customerreviewinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerreviewinsert`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_rating int,
in in_review text,
in in_reviewdate datetime,
out out_reviewId int
)
begin
-- -------------------comment--------------------------------------
-- 1. trigger the actioninsert stored procedure to handle any required results for this action
-- 2. create a new review record (review) with the supplied details - (nb: the review.hidereview value is to be set to "false")
-- ----------------------------------------------------------------
declare v_actionid int;
declare  v_ownerid int;

-- select @actionid ;
   /*   declare exit handler for sqlexception
      begin
        -- error
      resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
     -- resignal;
     -- rollback;
    end;
    
    start transaction; */

 

    set v_actionid =(select actionid from actions where name ='Rate & Review');
    set v_ownerid  =(select ownerid from community where communityid =in_communityid);
    
    CALL actioninsert(in_communityid, in_communitygroupid,v_actionid, v_ownerid  , in_supplierid ,in_customerid, 'Rate & Review', 0.00,null,@supplieractionid);
 
 insert into review (customerid,supplierid,communityid,communitygroupid,rating,review,reviewdate,hidereview,supplieractionid)
        values(in_customerid,in_supplierid,in_communityid,in_communitygroupid,in_rating,in_review,in_reviewdate,false,@supplieractionid);
        
    set out_reviewId= last_insert_id();
    
-- Get Communication details to send it as email		
		select sa.supplieractionid,sa.customerid , sa.supplierid , sa.communityid , sa.communitygroupid, 
				r.ReviewID , sa.actiondate , sa.detail as actionname, r.review, 
				c.email as customeremail , c.firstname as CustomerFirstName  , c.lastname as CustomerLastName, 
				s.email as supplieremail , s.companyname as suppliername , cg.communityname , cg.communitygroupname
				from review r 
				inner join supplieraction sa on r.supplieractionid = sa.supplieractionid 
				inner join customer c on c.customerid = sa.customerid
				inner join supplier s on s.supplierid = sa.supplierid
				inner join vw_communitygroup cg on cg.communitygroupid = sa.communitygroupid  
				where reviewid = out_reviewId;
  --  commit;
 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customerreviewselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerreviewselect`(
in in_reviewid int
)
begin
-- ---------------comment--------------------------------------
-- 1. retrieve the details of a review from the supplied reviewid (review)
-- 2. return the details
-- ------------------------------------------------------------

    select sql_no_cache reviewid,customerid,supplierid,communityid,communitygroupid,rating,review,reviewdate,hidereview from review where reviewid=in_reviewid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customerreviewsselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerreviewsselect`(
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int
)
begin
-- -----------------comment--------------------------------------
-- 1. retrieve all the reviews for the given supplier within the given community - community group (review)
-- 2. return the results
-- --------------------------------------------------------------

    select sql_no_cache reviewid,customerid,supplierid,communityid,communitygroupid,rating,review,reviewdate,hidereview from review
     where supplierid=in_supplierid and communityid=in_communityid and communitygroupid=in_communitygroupid;
     
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customersearch` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customersearch`(
in in_searchterm varchar(50),
in in_communityid int,
in in_supplierid int
)
begin
-- -----------comment-------------------------------------
-- 1. if the searchterm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--      use the supplied search term to search across customer.firstname, customer.lastname and customer.handle) for the given communityid (customercommunity.communityid) 
--      and supplierid (suppliershortlist.supplierid) - nb: if the supplierid or searchterm is not supplied, then ignore from search filter
-- 2. return the results
-- -------------------------------------------------------

    select c.customerid,c.email,c.mobilephone,c.firstname,c.lastname,c.handle,c.gender,c.datejoined from customer c inner join customercommunity cc on c.customerid=cc.customerid
    inner join suppliershortlist ss on c.customerid=ss.customerid where (c.firstname like concat('%',in_searchterm,'%') or c.lastname like concat('%',in_searchterm,'%')
     or c.handle like concat('%',in_searchterm,'%'));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customersearchbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customersearchbysupplier`(
in in_handle varchar(50),
in in_firstname varchar(50),
in in_lastname varchar(50),
in in_email varchar(100),
in in_communitygroupid int,
in in_actionid int,
in in_supplierid int,
in in_customerid int
)
begin
-- ---------------------comment--------------------------------------
-- the customers associated to the supplier via the supplieraction table will be searched with the selected filters applied.
-- ------------------------------------------------------------------

        select cu.customerid,cu.email,cu.mobilephone,cu.firstname,cu.lastname,cu.handle,cu.gender,cu.datejoined -- ,a.name as actionname
            ,c.name as communityname, cg.name as communitygroupname, concat(c.name,' - ',cg.name) as communitycommunitygroupname
            ,(select name from actions a1 inner join supplieraction sa1 on a1.actionid=sa1.actionid 
				where  sa1.customerid=sa.customerid  and sa1.supplierid=sa.supplierid 
					and sa1.supplieractionid= (select max(supplieractionid) from supplieraction where  customerid=sa1.customerid and supplierid=sa1.supplierid )) as actionname
            
        from customer cu inner join supplieraction sa on cu.customerid=sa.customerid
            inner join actions a on sa.actionid=a.actionid inner join communitygroup cg on cg.communitygroupid=sa.communitygroupid
            inner join community c on cg.communityid=c.communityid
           -- left join supplieraction sa1 on(sa.customerid=sa1.customerid and sa.actiondate<sa1.actiondate and sa.supplierid=sa1.supplierid )
          --  left join actions a1 on sa1.actionid=a1.actionid

        where  sa.supplierid=in_supplierid and (cu.firstname like concat('%',in_firstname,'%') or in_firstname='') 
			and  (cu.lastname like concat('%',in_lastname,'%') or in_lastname='') and (cu.email like concat('%',in_email,'%') or in_email='')
			and (cu.handle like concat('%',in_handle,'%') or in_handle='') and (a.actionid=in_actionid or in_actionid=0)
                and (sa.communitygroupid=in_communitygroupid or in_communitygroupid=0) and (sa.customerid=in_customerid or in_customerid=0)
			group by  cu.customerid -- ,c.communityid,cg.communitygroupid
         ;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customerselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerselect`(
in in_customerid int
)
begin
-- --------comment----------------------------------------
-- 1. retrieve the details of the given customerid from the customer table (customer.customerid)
-- 2. return the results
-- -------------------------------------------------------

    select customerid,email,mobilephone,firstname,lastname,handle,gender,datejoined from customer where customerid=in_customerid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `customerselectall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customerselectall`(
)
BEGIN
-- ----------------------comment-----------------------------
-- get all customer
-- ----------------------------------------------------------
        
        select customerid,email,mobilephone,firstname,lastname,handle,gender,datejoined from customer;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customersupplieractionattachmentinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customersupplieractionattachmentinsert`(
in in_supplieractionid int,
in in_attachment mediumblob,
in in_filename varchar(500)
)
BEGIN
-- --------------comment----------------------------------
-- insert supplier action attachment
-- -------------------------------------------------------

		insert into customersupplieractionattachment(CustomerSupplierActionAttachmentID,attachment,filename)
			values (in_supplieractionid,in_attachment,in_filename);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customersupplieractionattachmentselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customersupplieractionattachmentselect`(
in in_supplieractionid int
)
BEGIN
-- --------------------comment-----------------------------
-- 
-- --------------------------------------------------------

		select CustomerSupplierActionAttachmentID,attachment,filename from customersupplieractionattachment where CustomerSupplierActionAttachmentID=in_supplieractionid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customersuppliercommunicationinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customersuppliercommunicationinsert`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_actionid int,
in in_actionname varchar(50),
in in_message text,
in in_parentsupplieractionid int
)
BEGIN
-- --------------------------------comment-----------------------------------
-- 
-- --------------------------------------------------------------------------
declare v_supplieractionid int ;
        declare  v_ownerid int;
        set v_ownerid  =(select ownerid from community where communityid =in_communityid);
		set  v_supplieractionid = 0;
        CALL actioninsert(in_communityid, in_communitygroupid,in_actionid, v_ownerid  , in_supplierid ,in_customerid, in_actionname, 0.00,in_parentsupplieractionid,@supplieractionid);
        set  v_supplieractionid = @supplieractionid ;
		if(v_supplieractionid >  0) then
		begin 				

		insert into customersuppliercommunication(supplieractionid,message) values(@supplieractionid,in_message);
 
-- Get Communication details to send it as email		
		select sa.supplieractionid,sa.customerid , sa.supplierid , sa.communityid , sa.communitygroupid, 
				csc.communicationid , sa.actiondate , sa.detail as actionname, csc.message, 
				c.email as customeremail , c.firstname as CustomerFirstName  , c.lastname as CustomerLastName, 
				s.email as supplieremail , s.companyname as suppliername , cg.communityname , cg.communitygroupname
				from customersuppliercommunication csc 
				inner join supplieraction sa on csc.supplieractionid = sa.supplieractionid 
				inner join customer c on c.customerid = sa.customerid
				inner join supplier s on s.supplierid = sa.supplierid
				inner join vw_communitygroup cg on cg.communitygroupid = sa.communitygroupid  
				where communicationid = last_insert_id();
		end;
		end if;

 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customertransactionsearch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `customertransactionsearch`(
in in_ownerid int,
in in_search varchar(50),
in in_communityid int,
in in_communitygroupid int,
in in_rowindex int,
in in_rowcount int
)
BEGIN
-- ----------------------comment------------------------------------

-- -----------------------------------------------------------------

	drop table if exists tmp;
	create temporary table tmp(customerid int);

	insert into tmp(customerid)
	select cu.customerid  from customer cu inner join customercommunity cc on cu.customerid=cc.customerid
    inner join community c on c.communityid=cc.communityid inner join currency cur on cur.currencyid=c.currencyid
    where c.ownerid=in_ownerid and (match(cu.firstname,cu.lastname,cu.handle) against (in_search in boolean mode)  or in_search='')
    group by cu.customerid order by cu.lastname,cu.firstname limit in_rowindex,in_rowcount;

    -- The total amount of revenue the community owner has received off the transactions this customer has engaged in.
    
    select  SQL_CALC_FOUND_ROWS cu.customerid,cu.Firstname,cu.lastname,cu.Handle,cur.currencyid,cur.isocode as currencyname
    ,coalesce((select sum(th.amount) from communityownertransactionhistory th inner join billingreference b on b.communityownertransactionhistoryid=th.communityownertransactionhistoryid
    inner join suppliercommunitytransactionhistory sth on sth.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid 
    where  th.amount>0 and  sth.customerid=cu.customerid),0) as totalrevenue

    ,coalesce((select sum(th.amount) from communityownertransactionhistory th inner join billingreference b on b.communityownertransactionhistoryid=th.communityownertransactionhistoryid
    inner join suppliercommunitytransactionhistory sth on sth.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid 
    where  th.amount<0 and  sth.customerid=cu.customerid),0) as totalspend

    from customer cu inner join customercommunity cc on cu.customerid=cc.customerid
    inner join community c on c.communityid=cc.communityid inner join currency cur on cur.currencyid=c.currencyid
    where c.ownerid=in_ownerid and (match(cu.firstname,cu.lastname,cu.handle) against (in_search in boolean mode)  or in_search='')
    group by cu.customerid order by cu.lastname,cu.firstname limit in_rowindex,in_rowcount;

 SELECT FOUND_ROWS() as totalrecords;
	
    -- The total amount of revenue the community owner has received off the transactions this customer has engaged in within this community.
     
    select cu.customerid,cu.Firstname,cu.lastname,cu.Handle,c.Name as Communityname,c.communityid,cur.currencyid,cur.isocode as currencyname
    ,(select count(customerid) from review where customerid=cu.customerid and communityid=c.communityid  ) as reviewcount

    ,coalesce((select sum(th.amount) from communityownertransactionhistory th inner join billingreference b on b.communityownertransactionhistoryid=th.communityownertransactionhistoryid
    inner join suppliercommunitytransactionhistory sth on sth.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid 
    where th.communityid=c.communityid  and th.amount>0 and  sth.customerid=cu.customerid),0) as totalrevenue

    ,coalesce((select sum(th.amount) from communityownertransactionhistory th inner join billingreference b on b.communityownertransactionhistoryid=th.communityownertransactionhistoryid
    inner join suppliercommunitytransactionhistory sth on sth.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid 
    where th.communityid=c.communityid  and th.amount<0 and  sth.customerid=cu.customerid),0) as totalspend

    from customer cu inner join customercommunity cc on cu.customerid=cc.customerid
    inner join community c on c.communityid=cc.communityid inner join currency cur on cur.currencyid=c.currencyid
	inner join tmp on tmp.customerid=cu.customerid
     where c.ownerid=in_ownerid and (match(cu.firstname,cu.lastname,cu.handle) against (in_search in boolean mode)  or in_search='')
        and (c.communityid=in_communityid or in_communityid=0)
    group by c.communityid;
    
    -- The total amount the customer has spent across all transactions within this community group.
    
    select cu.customerid,cu.Firstname,cu.lastname,cu.Handle,c.Name as Communityname,cg.Name as CommunitygroupName,c.communityid,cg.communitygroupid,cur.currencyid,cur.isocode as currencyname 
    ,(select count(customerid) from review where customerid=cu.customerid and communityid=c.communityid and communitygroupid=cg.communitygroupid ) as reviewcount

    ,coalesce((select sum(th.amount) from communityownertransactionhistory th inner join billingreference b on b.communityownertransactionhistoryid=th.communityownertransactionhistoryid
    inner join suppliercommunitytransactionhistory sth on sth.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid 
    where th.communityid=c.communityid and th.communitygroupid=cg.communitygroupid and th.amount>0 and  sth.customerid=cu.customerid),0) as totalrevenue

    ,coalesce((select sum(th.amount) from communityownertransactionhistory th inner join billingreference b on b.communityownertransactionhistoryid=th.communityownertransactionhistoryid
    inner join suppliercommunitytransactionhistory sth on sth.suppliercommunitytransactionhistoryid=b.suppliercommunitytransactionhistoryid 
    where th.communityid=c.communityid and th.communitygroupid=cg.communitygroupid and th.amount<0 and  sth.customerid=cu.customerid),0) as totalspend

    ,(select count(supplierid) from supplieraction sa inner join actions a on sa.actionid=a.actionid where  communityid=c.communityid 
    and communitygroupid=cg.communitygroupid and name='view') as viewscount
    
    from customer cu inner join customercommunity cc on cu.customerid=cc.customerid
    inner join community c on c.communityid=cc.communityid inner join currency cur on cur.currencyid=c.currencyid
    inner join communitygroup cg on cg.communityid=c.communityid
    inner join tmp on tmp.customerid=cu.customerid

    where c.ownerid=in_ownerid and (match(cu.firstname,cu.lastname,cu.handle) against (in_search in boolean mode)  or in_search='')
        and (c.communityid=in_communityid or in_communityid=0) and (cg.communitygroupid=in_communitygroupid or in_communitygroupid=0);



	drop table if exists tmp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customerupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerupdate`(
in in_customerid int,
in in_email varchar(100),
in in_mobilephone varchar(50),
in in_firstname varchar(50),
in in_lastname varchar(50),
in in_handle varchar(50),
in in_gender char(10)
)
begin
-- --------------comment----------------------------------
-- 1. update the existing customer record (customer.customerid) with the supplied details (customer)
-- -------------------------------------------------------

    update customer set email=in_email, mobilephone=in_mobilephone, firstname=in_firstname, lastname=in_lastname, handle=in_handle, gender=in_gender
     where customerid=in_customerid;
     
     
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `debitvirtualcommunityaccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `debitvirtualcommunityaccount`(
in in_id int,
in in_entity varchar(50),
in in_communityid int,
in in_communitygroupid int,
in in_description varchar(200),
in in_amount decimal(10,2),
in in_dateapplied datetime,-- not in use(used now())
in in_customerid int
)
begin
-- ----------------comment-----------------------------------------------
-- 1. if the supplied entity is "supplier"
--      a) retrieve the current balance for the supplier's community virtual account (suppliercommunitytransactionhistory.balance) based on the most recent transaction
--          ( max(suppliercommunitytransactionhistory.dateapplied) ) for the given supplier-community relationship
--      b) calculate the new balance for the supplier's community virtual account from the current balance and the debit amount
--      (suppliercommunitytransactionhistory.balance - amount)
--      c) add a new transaction record to the supplier's community virtual account based on the calculated balance and the supplied details (suppliercommunitytransactionhistory)
--  2. if the supplied entity is "community owner"
--      a) retrieve the current balance for the community owner's community virtual account (communityownertransactionhistory.balance) based on the most recent transaction 
--          ( max(communityownertransactionhistory.dateapplied) ) for the given community owner-community relationship
--      b) calculate the new balance for the community owner's community virtual account from the current balance and the debit amount 
--          (communityownertransactionhistory.balance - amount)
--      c) add a new transaction record to the community owner's community virtual account based on the calculated balance and the supplied details 
--          (communityownertransactionhistory)
-- ----------------------------------------------------------------------
 declare v_balance decimal(10,2);
    set v_balance=1.00;
    
    if(in_entity='supplier') then
     begin
 

select 
    coalesce((select 
                    coalesce(balance, 0)
                from
                    suppliercommunitytransactionhistory
                where
                    supplierid = in_id
                        and communityid = in_communityid
                        and SupplierCommunityTransactionHistoryID = (select 
                            max(SupplierCommunityTransactionHistoryID)
                        from
                            suppliercommunitytransactionhistory
                        where
                            supplierid = in_id
                                and communityid = in_communityid)),
            0)
into v_balance;
-- select v_balance;
 
/* select 
    v_balance,
    in_amount,
    v_balance - in_amount,
    in_id,
    in_communityid;*/

        insert into suppliercommunitytransactionhistory(supplierid,communityid,communitygroupid,description,amount,dateapplied,balance,customerid)
         values(in_id,in_communityid,in_communitygroupid,in_description,(in_amount*-1),now(),(v_balance-in_amount),in_customerid); 
         
select 
    suppliercommunitytransactionhistoryid,
    supplierid,
    communityid,
    communitygroupid,
    description,
    amount,
    dateapplied,
    balance,
    customerid
from
    suppliercommunitytransactionhistory
where
    suppliercommunitytransactionhistoryid = last_insert_id();
            
     end;
     
     elseif(in_entity='community owner') then
     begin
     
      set v_balance=coalesce( (select coalesce(balance,0) from communityownertransactionhistory where ownerid=in_id and communityid=in_communityid 
                      and communityownertransactionhistoryid=(select max(communityownertransactionhistoryid) from communityownertransactionhistory 
						where ownerid=in_id and communityid=in_communityid  )
                    ),0);
                    
        insert into communityownertransactionhistory(ownerid,communityid,communitygroupid,description,amount,dateapplied,balance)
         values(in_id,in_communityid,in_communitygroupid,in_description,(in_amount*-1),now(),(v_balance-in_amount));
         
select 
    communityownertransactionhistoryid,
    ownerid,
    communityid,
    communitygroupid,
    description,
    amount,
    dateapplied,
    balance
from
    communityownertransactionhistory
where
    communityownertransactionhistoryid = last_insert_id();
         
     end;
    end if;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `errorloginsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `errorloginsert`(
in in_description varchar(500),
in in_details varchar(8000),
in in_timestamp datetime
)
begin
-- -----------comment-----------------------------------
-- insert errorlog with supplied details (errorlogs)
-- -----------------------------------------------------

    insert into errorlogs(description,details,timestamp) values(in_description,in_details,in_timestamp);
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `getdatetime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `getdatetime`()
BEGIN
-- ---------------comment-------------
-- get myql server datetime
-- -----------------------------------
		select now();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `oauthaccounttokenupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `oauthaccounttokenupdate`(
in in_provider varchar(50),
in in_provideruserid varchar(200),
in in_token varchar(50)
)
BEGIN
-- ----------------------comment----------------
-- Change password
-- ---------------------------------------------
		if(exists(select oauthaccountid from oauthaccount where token=in_token and provider=in_provider and provideruserid=in_provideruserid)) then
			select '1';
		else
			begin
				update oauthaccount set token=in_token where provider=in_provider and provideruserid=in_provideruserid;
				select '0';
			end;
		end if;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `owneraccountbalancebycommunity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `owneraccountbalancebycommunity`(
in in_ownerid int,
in in_communityid int
)
BEGIN
-- -------------comment---------------------------------
-- The owner current Virtual Community Account balance for the given community.
-- ------------------------------------------------------

		select  coalesce(sum(balance),0) as balance from communityownertransactionhistory 
           where ownerid=in_ownerid and communityid=in_communityid  and communityownertransactionhistoryid= 
             (select  max(communityownertransactionhistoryid) from communityownertransactionhistory where  communityid=in_communityid and ownerid=in_ownerid
              );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `owneraccountsummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `owneraccountsummary`(
in in_ownerid int
)
BEGIN
-- -------------------comment-------------------------------------
-- The current virtual account balance for the community owner as associated to the relevant community and community currency.
-- ---------------------------------------------------------------

        select c.communityid,c.name as communityname
        ,coalesce( (select sum(balance) from communityownertransactionhistory 
        where communityownertransactionhistoryid=(select max(communityownertransactionhistoryid) from communityownertransactionhistory where communityid=c.communityid)
        and ct.ownerid=c.ownerid),0) as balance,cu.currencyid,cu.isocode as currencyname
        
        from community c left join communityownertransactionhistory ct on ct.communityid=c.communityid
			inner join currency cu on cu.currencyid=c.currencyid
        where c.ownerid=in_ownerid
        group by communityid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ownerselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `ownerselect`(
in in_ownerid int
)
begin
-- -------------------comment---------------------------
--  retrieve the community owner record associated to the given ownerid (owner.ownerid)
-- -----------------------------------------------------

        select sql_no_cache ownerid,companyname,email,businessnumber,preferredpaymentcurrencyid,primaryphone
                ,otherphone,dateadded,website,addressline1,addressline2,addresscity,addressstate,addresspostalcode
                ,addresscountryid,billingname,billingaddressline1,billingaddressline2,billingaddresscity,billingaddressstate
                ,billingaddresspostalcode,billingaddresscountryid, c1.countryname as addresscountryname,c2.countryname as billingaddresscountryname
        from owner o left join country c1 on o.addresscountryid=c1.countryid
            left join country c2 on o.billingaddresscountryid=c2.countryid 
        where ownerid=in_ownerid ;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ownerselectall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `ownerselectall`()
BEGIN
-- ----------------comment-------------
-- Get all owner
-- ------------------------------------

		select ownerid,companyname,email from owner;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ownerupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ownerupdate`(
in in_ownerid int,
in in_companyname varchar(50),
in in_email varchar(200),
in in_businessnumber varchar(50),
in in_preferredpaymentcurrencyid int,
in in_primaryphone varchar(50),
in in_otherphone varchar(50),
in in_dateadded datetime,
in in_website varchar(50),
in in_addressline1 varchar(150),
in in_addressline2 varchar(150),
in in_addresscity varchar(50),
in in_addressstate varchar(50),
in in_addresspostalcode varchar(50),
in in_addresscountryid int,
in in_billingname varchar(150),
in in_billingaddressline1 varchar(150),
in in_billingaddressline2 varchar(150),
in in_billingaddresscity varchar(50),
in in_billingaddressstate varchar(50),
in in_billingaddresspostalcode varchar(50),
in in_billingaddresscountryid varchar(50)
)
begin
-- -----------------comment--------------------------------
-- 1. update the details of an existing community owner record (owner.ownerid) with the supplied details.
-- --------------------------------------------------------

    update owner set companyname=in_companyname, email=in_email, businessnumber=in_businessnumber, preferredpaymentcurrencyid=in_preferredpaymentcurrencyid
      , primaryphone=in_primaryphone, otherphone=in_otherphone, dateadded=in_dateadded, website=in_website, addressline1=in_addressline1, addressline2=in_addressline2
      , addresscity=in_addresscity, addressstate=in_addressstate, addresspostalcode=in_addresspostalcode, addresscountryid=in_addresscountryid
      , billingname=in_billingname, billingaddressline1=in_billingaddressline1, billingaddressline2=in_billingaddressline2, billingaddresscity=in_billingaddresscity
      , billingaddressstate=in_billingaddressstate, billingaddresspostalcode=in_billingaddresspostalcode, billingaddresscountryid=in_billingaddresscountryid
    where ownerid=in_ownerid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `paymenttransactioninsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `paymenttransactioninsert`(
in in_oauthaccountid int,
in in_transactionamount decimal(10,2),
in in_ordercode varchar(45),
in in_echodata varchar(500),
in in_successmessage varchar(500),
in in_errormessagae varchar(500),
in in_responsexml varchar(500)
)
BEGIN

		insert into paymenttransaction(oauthaccountid,transactionamount,ordercode,echodata,successmessage,errormessage,responsexml)
				values(in_oauthaccountid,in_transactionamount,in_ordercode,in_chodata,in_successmessage,in_errormessage,in_responsexml);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `paypaltransactioninsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `paypaltransactioninsert`(
in in_oauthaccountid int,
in in_transactionid varchar(45),
in in_responsemessage varchar(500),
in in_status varchar(50),
in in_responsetext varchar(5000),
in in_transactiondate datetime
)
BEGIN

		insert into paypaltransaction(oauthaccountid,transactionid,responsemessage,status,responsetext,transactiondate)
			values(in_oauthaccountid,in_transactionid,in_responsemessage,in_status,in_responsetext,in_transactiondate);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `preferredshortlistupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `preferredshortlistupdate`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int
)
begin
-- ------------comment----------------------------------------------
-- 1. remove all shortlist supplier based on customer & community group
-- 2. insert selected supplier as shortlist
-- -----------------------------------------------------------------

 declare exit handler for sqlexception
      begin
        -- error
      resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
      resignal;
      rollback;
    end;
    
    start transaction;
    
    delete from suppliershortlist where  customerid=in_customerid and communitygroupid=in_communitygroupid;
    
    insert into suppliershortlist (customerid,communityid,communitygroupid,supplierid)
        values(in_customerid,in_communityid,in_communitygroupid,in_supplierid);
        
    commit;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `registernewaccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registernewaccount`(
in in_oauthprovider varchar(50),
in in_oauthuserid varchar(200),
in in_oauthtoken varchar(50)
)
begin
-- --------comment---------------------------------------------
-- 1. create new account within the system based on the supplied details (oauthaccount)
-- ------------------------------------------------------------
    declare id int;

    if(in_oauthprovider='general') then
    begin
        insert into oauthaccount (provider,provideruserid,token,active) values (in_oauthprovider,in_oauthuserid,in_oauthtoken,false);
	set id=last_insert_id();
	end;
    else
    begin
        insert into oauthaccount (provider,provideruserid,token,active) values (in_oauthprovider,in_oauthuserid,in_oauthtoken,true);
        set id=last_insert_id();
	end;
    end if;
	select id;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `registernewcommunityowner` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registernewcommunityowner`(
in in_oauthaccountid int,
in in_companyname varchar(50),
in in_email varchar(200),
in in_businessnumber varchar(50),
in in_preferredpaymentcurrencyid int,
in in_primaryphone varchar(50),
in in_otherphone varchar(50),
in in_dateadded datetime,
in in_website varchar(50),
in in_addressline1 varchar(150),
in in_addressline2 varchar(150),
in in_addresscity varchar(50),
in in_addressstate varchar(50),
in in_addresspostalcode varchar(50),
in in_addresscountryid int,
in in_billingname varchar(150),
in in_billingaddressline1 varchar(150),
in in_billingaddressline2 varchar(150),
in in_billingaddresscity varchar(50),
in in_billingaddressstate varchar(50),
in in_billingaddresspostalcode varchar(50),
in in_billingaddresscountryid varchar(50)
)
begin
-- --------comment------------------------------------------------------
-- 1. create a new community owner record with the supplied details (owner)
-- 2. associate the newly created owner record (owner.ownerid) with the supplied oauth account (oauthaccount.oauthaccountid) (entityoauthaccount)
-- 3. insert/update usersecurity.communityowner to userecurity.oauthaccountid
-- ---------------------------------------------------------------------

    declare id int;
    declare exit handler for sqlexception
      begin
        -- error
        resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
     resignal;
        -- warning
     rollback;
    end;
    
    start transaction;
    
        insert into owner (companyname,email,businessnumber,preferredpaymentcurrencyid,primaryphone,otherphone,dateadded,website,addressline1,addressline2,addresscity
            ,addressstate,addresspostalcode,addresscountryid,billingname,billingaddressline1,billingaddressline2,billingaddresscity,billingaddressstate,billingaddresspostalcode
            , billingaddresscountryid)
        values (in_companyname,in_email,in_businessnumber,in_preferredpaymentcurrencyid,in_primaryphone,in_otherphone,in_dateadded,in_website,in_addressline1,in_addressline2
            ,in_addresscity,in_addressstate,in_addresspostalcode,in_addresscountryid,in_billingname,in_billingaddressline1,in_billingaddressline2,in_billingaddresscity
            ,in_billingaddressstate,in_billingaddresspostalcode,in_billingaddresscountryid);
        
        
        set id=(select last_insert_id());
        
        insert into entityoauthaccount (entitytype,entityid,oauthaccountid) values ('communityowner',id,in_oauthaccountid);
        
        if(exists(select oauthaccountid from usersecurity where oauthaccountid=in_oauthaccountid)) then
            update usersecurity set communityowner=1 where oauthaccountid=in_oauthaccountid;
        else
            insert into usersecurity(oauthaccountid,administrator,communityowner,supplier,customer) values (in_oauthaccountid,0,1,0,0);
        end if;
        
        select id;
        
    commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `registernewsupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `registernewsupplier`(
in in_oauthaccountid int,
in in_companyname varchar(50),
in in_email varchar(200),
in in_businessnumber varchar(50),

in in_primaryphone varchar(50),
in in_otherphone varchar(50),
in in_dateadded datetime,
in in_website varchar(50),
in in_addressline1 varchar(150),
in in_addressline2 varchar(150),
in in_addresscity varchar(50),
in in_addressstate varchar(50),
in in_addresspostalcode varchar(50),
in in_addresscountryid int,
in in_billingname varchar(150),
in in_billingaddressline1 varchar(150),
in in_billingaddressline2 varchar(150),
in in_billingaddresscity varchar(50),
in in_billingaddressstate varchar(50),
in in_billingaddresspostalcode varchar(50),
in in_billingaddresscountryid varchar(50),
in in_longitude decimal(10,4),
in in_latitude decimal(10,4),
in in_profilecompleteddate datetime,
in in_quoteterms varchar(250),
in in_depositpercent decimal(10,2),
in in_depositterms varchar(250),
in in_addresscountryname varchar(100),
in in_billingcountryname varchar(100)
)
begin
-- -------comment--------------------------------------------------
-- 1. create a new supplier record with the supplied details (supplier)
-- 2. associate the newly created supplier record (supplier.supplierid) with the supplied oauth account (oauthaccount.oauthaccountid) (entityoauthaccount)
-- 3. insert/update usersecurity.supplier to userecurity.oauthaccountid
-- ----------------------------------------------------------------
    declare id int;
	declare v_countryid int;
	declare v_billingcountryid int;
  /*  declare exit handler for sqlexception

      begin
        -- error
        resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
        resignal;
     rollback;
    end;
    
    start transaction;*/

		
		set v_countryid=0;
		set v_billingcountryid=0;

		if(in_addresscountryname='') then
			set v_countryid=null;
		else
			select coalesce(countryid,0) into v_countryid from country where countryname=in_addresscountryname;
			if(v_countryid=0) then
				insert into country(countryname) values(in_addresscountryname);
				set v_countryid=(select last_insert_id());
			end if;
		end if;

		if(in_billingcountryname='') then
			set v_billingcountryid=null;
		else
			select coalesce(countryid,0) into v_billingcountryid from country where countryname=in_billingcountryname;
			if(v_billingcountryid=0) then
				insert into country(countryname) values(in_billingcountryname);
				set v_billingcountryid=(select last_insert_id());
			end if;
		end if;

        insert into supplier (companyname,email,website,primaryphone,otherphone,addressline1,addressline2,addresscity,addressstate,addresspostalcode,addresscountryid
          ,billingname,billingaddressline1,billingaddressline2,billingaddresscity,billingaddressstate,billingaddresspostalcode,billingaddresscountryid,businessnumber
          ,longitude,latitude,dateadded,profilecompleteddate,quoteterms,depositpercent,depositterms)
          
        values(in_companyname,in_email,in_website,in_primaryphone,in_otherphone,in_addressline1,in_addressline2,in_addresscity,in_addressstate,in_addresspostalcode
          ,v_countryid,in_billingname,in_billingaddressline1,in_billingaddressline2,in_billingaddresscity,in_billingaddressstate,in_billingaddresspostalcode
          ,v_billingcountryid,in_businessnumber,in_longitude,in_latitude,in_dateadded,in_profilecompleteddate,in_quoteterms,in_depositpercent,in_depositterms);
            
        set id=(select last_insert_id());
          
          insert into entityoauthaccount (entitytype,entityid,oauthaccountid) values ('supplier',id,in_oauthaccountid);
          
          if(exists(select oauthaccountid from usersecurity where oauthaccountid=in_oauthaccountid)) then
            update usersecurity set supplier=1 where oauthaccountid=in_oauthaccountid;
        else
            insert into usersecurity(oauthaccountid,administrator,communityowner,supplier,customer) values (in_oauthaccountid,0,0,1,0);
        end if;
        
          select id;
          
   -- commit;


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewcountbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `reviewcountbysupplier`(
in in_supplierid int
)
begin
-- -------------comment--------------------------------------
-- Used in Supplier User Interface , Supplier Review page, For navigation link to review in different community group   
-- Revision : 01-07-2014 , The star rating was calculated using average function instead of sum (Refer Page: 125 , # Stars : the average star rating, )
-- Revision : 10-07-2014  , Select only active community & group in which the supplier have active membership
-- ----------------------------------------------------------

        select communityid,communitygroupid, concat(communityname,' - ',communitygroupname,' (',round(star,1), ' star(s) from ',reviews,' review(s) - ',pending,' pending)') as menu from
        (
         select c.communityid,c.name as communityname,cg.name as communitygroupname,cgs.communitygroupid,count(r.reviewid) as reviews
                ,coalesce(avg(rating),0) as star
		,coalesce((select count(reviewid) from review where reviewid not in
					(select rr.reviewid from reviewresponse rr inner join review r  on rr.reviewid=r.reviewid where supplierid=in_supplierid and communitygroupid=cg.communitygroupid)
				and supplierid=in_supplierid and communitygroupid=cg.communitygroupid  ),0) as pending
        from communitygroupsupplier cgs 
	    left join review r on cgs.SupplierID=r.supplierid and cgs.communitygroupid =r.CommunityGroupID  
		inner join communitygroup cg on cgs.communitygroupid=cg.communitygroupid and cg.active = 1
        inner join community c on cg.communityid=c.communityid and c.active = 1
        where cgs.supplierid=in_supplierid and cgs.isactive = 1

group by cgs.communitygroupid order by pending desc
        ) as tbl;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewhelpfulinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewhelpfulinsert`(
in in_reviewid int,
in in_customerid int
)
begin
-- -----------comment--------------------------------------------
-- 1. trigger the actioninsert stored procedure to handle any required results for this action
-- 2. insert a new 'review helpful' record (reviewhelpful) with the supplied reviewid and customerid
-- --------------------------------------------------------------

    insert into reviewhelpful(reviewid,customerid) values(in_reviewid,in_customerid);
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewhideupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `reviewhideupdate`(
in in_reviewid int,
in in_hidereview bit
)
BEGIN
-- -----------------------comment-------------------------------

-- -------------------------------------------------------------
    update review set HideReview = in_hidereview where reviewid = in_reviewid;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewresponseinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `reviewresponseinsert`(
in in_reviewid int,
in in_response text,
in in_responsedate datetime,
in in_supplieractionid int
)
begin
-- -----------------------comment-------------------------------
-- Called while Add Review Response 
-- 1. Insert the response to the review
-- 2. Call the action insert procedure
-- -------------------------------------------------------------


declare  v_communityid int;
declare  v_communitygroupid int;
declare v_actionid int;
declare  v_communityownerid int;
declare  v_supplierid int;
declare  v_customerid int;
declare  v_actiondetails varchar(200);
declare  v_actionamt decimal(10,2);



set v_actionid =(select actionid from actions where name ='Respond');
  
Select 'Respond' as actiondetails  , 0 as actionamt, r.communityid , r.communitygroupid , c.ownerid ,  r.supplierid , r.customerid  
into v_actiondetails  , v_actionamt, v_communityid ,v_communitygroupid ,  v_communityownerid , v_supplierid , v_customerid  
from review r inner join community c on r.communityid = c.communityid where r.reviewid = in_reviewid;
-- for debugging assigned values 
-- Select v_communityid ,v_communitygroupid , v_actionid , v_communityownerid , v_supplierid , v_customerid , v_actiondetails  , v_actionamt ;
if(in_supplieractionid>0) then
CALL  actioninsert(v_communityid, v_communitygroupid, v_actionid, v_communityownerid, v_supplierid , v_customerid , v_actiondetails , v_actionamt,in_supplieractionid,@supplieractionid);
else
CALL  actioninsert(v_communityid, v_communitygroupid, v_actionid, v_communityownerid, v_supplierid , v_customerid , v_actiondetails , v_actionamt,null,@supplieractionid);
end if;

   insert into reviewresponse(reviewid,response,responsedate,hideresponse,supplieractionid) 
values(in_reviewid,in_response,in_responsedate,false,@supplieractionid);

-- Get Communication details to send it as email		
		select sa.supplieractionid,sa.customerid , sa.supplierid , sa.communityid , sa.communitygroupid, 
				 sa.actiondate , sa.detail as actionname, r.response, 
				c.email as customeremail , c.firstname as CustomerFirstName  , c.lastname as CustomerLastName, 
				s.email as supplieremail , s.companyname as suppliername , cg.communityname , cg.communitygroupname
				from reviewresponse r 
				inner join supplieraction sa on r.supplieractionid = sa.supplieractionid 
				inner join customer c on c.customerid = sa.customerid
				inner join supplier s on s.supplierid = sa.supplierid
				inner join vw_communitygroup cg on cg.communitygroupid = sa.communitygroupid  
				where reviewresponseid = last_insert_id();
     
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewresponseselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewresponseselect`(
in in_reviewid int
)
begin
-- ---------comment--------------------------------------------
-- 1. retrieve the response detail for the given review (reviewresponse.reviewid)
-- 2. return the results
-- ------------------------------------------------------------

    select sql_no_cache reviewresponseid,reviewid,response,responsedate,hideresponse from reviewresponse where reviewid=in_reviewid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `rewardsselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rewardsselect`(
in in_customerid int,
in in_communityid int
)
begin
-- ---------comment---------------------------------------------
-- 1. retrieve all the rewards for the given customer - community (customerrewards)
-- 2. return the results
-- -------------------------------------------------------------

    select customerrewardid,communityid,customerid,rewarddate,communityrewardid,rewardname,rewarddescription,pointsapplied,triggeredeventsid
    from customerrewards where customerid=in_customerid and communityid=in_communityid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `rewardstallyselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rewardstallyselect`(
in in_customerid int,
in in_communityid int
)
begin
-- -----comment-------------------------------------------------
-- 1. retrieve the current reward points tally for the given customer in the context of the given community (customerpointstally)
-- 2. return the results
-- -------------------------------------------------------------

    select sql_no_cache customerid,communityid,pointstally from customerpointstally where customerid=in_customerid and communityid=in_communityid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `shortlistupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `shortlistupdate`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_add bit
)
begin
-- -----------comment---------------------------------------
-- 1. trigger the actioninsert stored procedure to handle any required results for this action
-- 2. if add = "true", then add the supplier to the customer's shortlist for the given community - community group (suppliershortlist)
-- 3. if add = "false", then remove the supplier from the customer's shortlist for the given community - community group (suppliershortlist)
-- ---------------------------------------------------------

    if(in_add=true) then
        insert into suppliershortlist(customerid,communityid,communitygroupid,supplierid)
        values(in_customerid,in_communityid,in_communitygroupid,in_supplierid);
        
    else 
        delete from suppliershortlist where  communityid=in_communityid and communitygroupid=in_communitygroupid;
          
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `socialmediaselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `socialmediaselect`()
begin
-- ---------------comment---------------------------------------------
-- get all social media
-- -------------------------------------------------------------------
    select socialmediaid, name from socialmedia order by name;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `splitter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `splitter`(
x varchar(255), delim varchar(12)
)
BEGIN
SELECT LENGTH(x) - LENGTH(REPLACE(x, delim, '')) into @Valcount;

-- SET @Valcount = substrCount(x,delim)+1;
SET @v1=0;
drop table if exists splitResults;
create temporary
table splitResults (split_value varchar(255));
WHILE (@v1 <= @Valcount) DO

set @val = 
replace(substring(substring_index(x, delim, @v1+1),
length(substring_index(x, delim, @v1 )) + 1), delim, '') ;

-- stringSplit(x,delim,@v1+1);

INSERT INTO splitResults (split_value) VALUES (@val);
SET @v1 = @v1 + 1;
END WHILE;
select * from splitResults;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplieraccountbalancebycommunity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplieraccountbalancebycommunity`(
in in_supplierid int,
in in_communityid int
)
BEGIN
-- -------------comment---------------------------------
-- The supplier current Virtual Community Account balance for the given community.
-- ------------------------------------------------------

		select  coalesce(sum(balance),0) as balance from suppliercommunitytransactionhistory 
           where supplierid=in_supplierid and communityid=in_communityid  and SupplierCommunityTransactionHistoryID= 
             (select  max(SupplierCommunityTransactionHistoryID) from suppliercommunitytransactionhistory where  communityid=in_communityid and supplierid=in_supplierid
              );


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplieractioncount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplieractioncount`(
in in_supplierid int
)
BEGIN
-- ----------------------comment-----------------------------
-- 
-- ----------------------------------------------------------

        select c.communityid,cg.communitygroupid, c.name as communityname,cg.name as communitygroupname
        from supplieraction sa inner join communitygroup cg on sa.communitygroupid=cg.communitygroupid
        inner join community c on cg.communityid=c.communityid 
        where sa.supplierid=in_supplierid group by sa.communitygroupid;

          select c.communityid,cg.communitygroupid, c.name,cg.name,a.name as actionname,count(sa.actionid) as actioncount
          from supplieraction sa inner join communitygroup cg on sa.communitygroupid=cg.communitygroupid
            inner join community c on cg.communityid=c.communityid inner join actions a on sa.actionid=a.actionid
           where sa.supplierid=in_supplierid group by sa.communitygroupid,a.name;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplieractionselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplieractionselect`(
in in_supplieractionid int
)
BEGIN
-- ----------------------comment--------------
-- Get supplier action by id
-- --------------------------------------------
	
			select sa.supplieractionid,sa.customerid,supplierid,sa.communityid,communitygroupid,sa.actionid,actiondate,detail,responseactionperformed,parentsupplieractionid
			,c.currencyid,isocode as currencyname,concat(cus.firstname,' ',cus.lastname,' (',cus.handle,')') as customername,a.name as actionname,cc.message
			,atch.CustomerSupplierActionAttachmentID,atch.filename			
			from supplieraction sa inner join community c on sa.communityid=c.communityid 
			inner join currency cu on c.currencyid=cu.currencyid
			inner join actions a on sa.actionid=a.actionid 
			inner join customer cus on cus.customerid=sa.customerid
			left join customersuppliercommunication cc on cc.supplieractionid=sa.supplieractionid
			left join customersupplieractionattachment atch on atch.CustomerSupplierActionAttachmentID=sa.supplieractionid
			where sa.supplieractionid=in_supplieractionid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplieractionselectbycommunitygroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplieractionselectbycommunitygroup`(
in in_supplierid int,
in in_communitygroupid int
)
BEGIN
-- ----------------------comment---------------------------------
-- Get all supplier action based on community group
-- --------------------------------------------------------------

        
            select sa.supplieractionid,sa.customerid,sa.actiondate,sa.detail,concat(cu.firstname,' ',cu.lastname,' (',cu.handle,')') as customername
            ,a.name as actionname,a.actionid,sa.communityid,sa.communitygroupid,coalesce(cq.CustomerQuoteID,0) as CustomerQuoteID
            from supplieraction sa  inner join customer cu on sa.customerid=cu.customerid
            inner join actions a on sa.actionid=a.actionid
			left join customerquote cq on cq.supplieractionid=sa.SupplierActionID
            where sa.supplierid=in_supplierid and sa.communitygroupid=in_communitygroupid
			order by sa.actiondate desc;

            select a.actionid,ar.responseid,sa.supplieractionid,a1.name as responsename from supplieraction sa 
            inner join actions a on sa.actionid=a.actionid inner join actionresponse ar on ar.actionid=a.actionid
            inner join actions a1 on a1.actionid=ar.responseid inner join triggeredevent te on te.actionid=a1.actionid
			left join supplieraction sa1 on sa1.ParentSupplierActionId=sa.supplieractionid  and sa1.actionid=ar.responseid
             where sa.supplierid=in_supplierid and sa.communitygroupid=in_communitygroupid  and te.isactive=1 and sa1.SupplierActionID is null
			order by sa.actiondate desc;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplieractionselectbycustomer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplieractionselectbycustomer`(
in in_customerid int,
in in_supplierid int

)
begin
-- ----------------comment------------------------------------------
-- get supplier action by customer & supplier
-- -----------------------------------------------------------------

    select sql_no_cache cu.email,cu.firstname,cu.lastname,cu.handle, sa.supplieractionid,sa.customerid,sa.supplierid
    ,coalesce(sa.communityid,cg.communityid) as communityid,sa.communitygroupid,sa.actionid
    ,sa.actiondate,sa.detail,sa.responseactionperformed,concat(c.name,' - ',cg.name) as communitycommunitygroupname,a.name as actionname
    -- ,coalesce(a1.name,a.name) as currentaction
		,(select name from actions a1 inner join supplieraction sa1 on a1.actionid=sa1.actionid 
		 where  sa1.customerid=sa.customerid  and sa1.supplierid=sa.supplierid 
		and sa1.supplieractionid= (select max(supplieractionid) from supplieraction where  customerid=sa1.customerid and supplierid=sa1.supplierid )) as currentaction

	, suppliernote,coalesce(q.customerquoteid,0) as quoteid
    
    from customer cu inner join supplieraction sa on cu.customerid=sa.customerid 
    inner join actions a on sa.actionid=a.actionid inner join communitygroup cg on cg.communitygroupid=sa.communitygroupid
    inner join community c on cg.communityid=c.communityid 
   -- left join supplieraction sa1 on(sa.customerid=sa1.customerid and sa.actiondate<sa1.actiondate and sa.supplierid=sa1.supplierid)
    -- left join actions a1 on sa1.actionid=a1.actionid
    left join suppliercustomernote cn on cn.supplierid=sa.supplierid and cn.customerid=cu.customerid and cn.communityid=c.communityid and cn.communitygroupid=cg.communitygroupid
	left join customerquote q on q.supplieractionid=sa.supplieractionid

    where cu.customerid=in_customerid and sa.supplierid=in_supplierid group by sa.supplieractionid order by sa.actiondate desc;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliercommunitycommunitygrouplist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliercommunitycommunitygrouplist`(
in in_supplierid int
)
begin
-- ---------------comment---------------------------------------------
-- get all community group
-- -------------------------------------------------------------------

    select sql_no_cache c.communityid,c.name as communityname,cg.communitygroupid,cg.name as communitygroupname,
        concat(c.name,' - ',cg.name) as communitycommunitygroup
    from communitygroupsupplier cgs  inner join communitygroup cg on cgs.communitygroupid=cg.communitygroupid
	inner join  community c on cg.communityid = c.communityid
   
    where cgs.supplierid=in_supplierid and cgs.isactive=true 
    order by c.name,cg.name;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliercommunitygroupBYcommunity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliercommunitygroupBYcommunity`(
in in_supplierid int,
in in_communityid int
)
BEGIN
-- -------------------comment---------------------------
-- Get supplier community group
-- -----------------------------------------------------

		 select sql_no_cache c.communityid,c.name as communityname,cg.communitygroupid,cg.name as communitygroupname,
        concat(c.name,' - ',cg.name) as communitycommunitygroup
    from communitygroupsupplier cgs  
	inner join communitygroup cg on cgs.communitygroupid=cg.communitygroupid
	inner join  community c on cg.communityid = c.communityid
   
    where cgs.supplierid=in_supplierid and c.communityid=in_communityid and cgs.isactive=true 
    order by c.name,cg.name;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliercommunitygroupselectallbycommunity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliercommunitygroupselectallbycommunity`(
in in_supplierid int,
in in_communityid int
)
BEGIN
-- -------------------comment---------------------------
-- Get supplier community group
-- -----------------------------------------------------

		 select sql_no_cache c.communityid,c.name as communityname,cg.communitygroupid,cg.name as communitygroupname,
        concat(c.name,' - ',cg.name) as communitycommunitygroup
    from communitygroupsupplier cgs  inner join communitygroup cg on cgs.communitygroupid=cg.communitygroupid
	inner join  community c on cg.communityid = c.communityid
   
    where cgs.supplierid=in_supplierid and c.communityid=in_communityid 
    order by c.name,cg.name;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliercommunitymembershipcount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliercommunitymembershipcount`(
in in_supplierid int
)
begin
-- ------------comment------------------------------------
-- retrieves total count of active and inactive community from the communitysupplier table for a particular supplier.
-- -------------------------------------------------------
select 

(select count(cs.communityid) from communitysupplier cs 
inner join community c on c.communityid = cs.communityid and c.active = 1 
where cs.isactive = 1 and cs.supplierid = in_supplierid) as active , 
(select count(cs.communityid) from communitysupplier cs 
inner join community c on c.communityid = cs.communityid and c.active = 0
where cs.isactive = 1 and cs.supplierid = in_supplierid)  as inactive ; 

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliercommunitytransactionselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliercommunitytransactionselect`(
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_fromdate date,
in in_todate date,
in in_rowindex int,
in in_rowcount int
)
begin
-- --------------------------comment----------------------------------------
-- Revision made to include all record for exporting if rowcount and rowindex equals 0
-- -------------------------------------------------------------------------
if(in_rowindex = 0 and in_rowcount = 0) then
begin
 select SQL_CALC_FOUND_ROWS st.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
                ,coalesce(cu.firstname,'n/a') as customername,dateapplied,amount,balance,cur.currencyid,cur.isocode as currencyname
        from suppliercommunitytransactionhistory st inner join community c on st.communityid=c.communityid
			inner join currency cur on cur.currencyid=c.currencyid
            left join communitygroup cg on st.communitygroupid=cg.communitygroupid left join customer cu on st.customerid=cu.customerid
        where st.supplierid=in_supplierid and (st.communityid=in_communityid or in_communityid=0)
            and (st.communitygroupid=in_communitygroupid or in_communitygroupid=0) 
            and (date(st.dateapplied)>=date(in_fromdate) or in_fromdate is null) 
			and (date(st.dateapplied)<=date(in_todate) or in_todate is null)
        order by st.dateapplied desc ;

end;
else
begin
 select SQL_CALC_FOUND_ROWS st.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
                ,coalesce(cu.firstname,'n/a') as customername,dateapplied,amount,balance,cur.currencyid,cur.isocode as currencyname
        from suppliercommunitytransactionhistory st inner join community c on st.communityid=c.communityid
			inner join currency cur on cur.currencyid=c.currencyid
            left join communitygroup cg on st.communitygroupid=cg.communitygroupid left join customer cu on st.customerid=cu.customerid
        where st.supplierid=in_supplierid and (st.communityid=in_communityid or in_communityid=0)
            and (st.communitygroupid=in_communitygroupid or in_communitygroupid=0) 
            and (date(st.dateapplied)>=date(in_fromdate) or in_fromdate is null) 
			and (date(st.dateapplied)<=date(in_todate) or in_todate is null)
        order by st.dateapplied desc 
		limit in_rowindex,in_rowcount;

end;

end if;
       
		SELECT FOUND_ROWS() as totalrecords;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliercreditsummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliercreditsummary`(
in in_supplierid int
)
begin
-- --------------------------comment---------------------------------------------------------------------------------------
-- Used in Supplier User Interface, Supplier account (Credit Summary)  ManageSupplierAccounts.aspx
-- ------------------------------------------------------------------------------------------------------------------------



select c.name,cs.communityid,cs.supplierid,
  

-- The supplier top up amount was considered as Credit Amount
coalesce((select sum(amount) from suppliercommunitytransactionhistory st
 where st.supplierid = in_supplierid and st.communityid = c.communityid and  st.amount>0	 and st.customerid is null ) ,0) as creditamt,

 
-- Included the revenue from all community group related to this community regardless of whether it is active or the supplier is active member in communitygroup
coalesce((select sum(transactionamount) from suppliertransactions where isquote = 0 and supplierid = in_supplierid and communityid = c.communityid) ,0) as totalrevenue,
 coalesce(balance,0) as balance , 
cu.currencyid,cu.isocode as currencyname
 from community c 
inner join communitysupplier cs on c.communityid = cs.communityid and cs.isactive = 1 
inner join currency cu on cu.currencyid=c.currencyid 
inner join vw_suppliercommunitybalance b on b.communityid = cs.communityid and b.supplierid = cs.supplierid
where cs.supplierid=in_supplierid

and c.active = 1 ;

 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliericondelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliericondelete`(
in in_supplierid int
)
BEGIN
-- ---------------------comment--------------------
-- delete suppliericon
-- ------------------------------------------------

		delete from suppliericon where supplierid=in_supplierid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliericoninsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliericoninsert`(
in in_supplierid int,
in in_icon mediumblob
)
begin
-- ---comment------------------------------------------------
-- insert a new suppliericon record with the supplied details (suppliedicon)
-- if already exists then update icon
-- ----------------------------------------------------------

    if(exists(select supplierid from suppliericon where supplierid=in_supplierid)) then
        update suppliericon set icon=in_icon where supplierid=in_supplierid;
    else
        insert into suppliericon(supplierid,icon) values(in_supplierid,in_icon);
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliericonselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliericonselect`(
in in_supplierid int
)
begin
-- --------------comment-------------------------------------
-- get supplier icon based on supplierid
-- ----------------------------------------------------------

    select sql_no_cache supplierid,icon from suppliericon where supplierid=in_supplierid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplierinsert`(
in in_companyname varchar(50),
in in_email varchar(200),
in in_website varchar(200),
in in_primaryphone varchar(50),
in in_otherphone varchar(50),
in in_addressline1 varchar(150),
in in_addressline2 varchar(150),
in in_addresscity varchar(50),
in in_addressstate varchar(50),
in in_addresspostalcode varchar(50),
in in_addresscountryid int,
in in_billingname varchar(150),
in in_billingaddressline1 varchar(150),
in in_billingaddressline2 varchar(150),
in in_billingaddresscity varchar(50),
in in_billingaddressstate varchar(50),
in in_billingaddresspostalcode varchar(50),
in in_billingaddresscountryid int,
in in_businessnumber varchar(50),
in in_longitude decimal(10,4),
in in_latitude decimal(10,4)
)
begin
-- -----------comment----------------------------------
-- 1. create a new supplier record (supplier) with the supplied details
-- ----------------------------------------------------

    insert into supplier(companyname,email,website,primaryphone,otherphone,addressline1,addressline2,addresscity,addressstate,addresspostalcode,addresscountryid
                         ,billingname,billingaddressline1,billingaddressline2,billingaddresscity,billingaddressstate,billingaddresspostalcode,billingaddresscountryid
                         ,businessnumber,longitude,latitude,dateadded)
    values(in_companyname,in_email,in_website,in_primaryphone,in_otherphone,in_addressline1,in_addressline2,in_addresscity,in_addressstate,in_addresspostalcode
            ,in_addresscountryid,in_billingname,in_billingaddressline1,in_billingaddressline2,in_billingaddresscity,in_billingaddressstate,in_billingaddresspostalcode
            ,in_billingaddresscountryid,in_businessnumber,in_longitude,in_latitude,now());
            
    select last_insert_id();
            
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierlogodelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierlogodelete`(
in in_supplierid int
)
BEGIN
-- --------------comment-------------------
-- delete supplierlogo	
-- ----------------------------------------
	
		delete from supplierlogo where supplierid=in_supplierid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierlogoinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplierlogoinsert`(
in in_supplierid int,
in in_logo mediumblob 
)
begin
-- ------------------comment---------------------------------
-- insert a new supplierlogo record with the supplied details (suppliedicon)
-- if already exist then update logo
-- ----------------------------------------------------------

    if(exists(select supplierid from supplierlogo where supplierid=in_supplierid)) then
        update supplierlogo set logo=in_logo where supplierid=in_supplierid;
    else
        insert into supplierlogo(supplierid,logo) values(in_supplierid,in_logo);
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierlogoselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplierlogoselect`(
in in_supplierid int
)
begin
-- ------------------comment----------------------------------
-- get supplier logo based on supplierid
-- -----------------------------------------------------------

    select sql_no_cache supplierid,logo from supplierlogo where supplierid=in_supplierid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliermonthlybilling` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliermonthlybilling`(
in in_fromdate date,
in in_todate	date
)
BEGIN
-- -------------------------------------------------
-- get all supplier transactions with in given date 
-- -------------------------------------------------

			select s.supplierid,s.companyname,s.email
        from suppliercommunitytransactionhistory st 
			 inner join supplier s on s.supplierid=st.supplierid
        where  (date(st.dateapplied)>=date(in_fromdate) or in_fromdate is null) 
			and (date(st.dateapplied)<=date(in_todate) or in_todate is null)
			group by s.supplierid
        order by s.supplierid ;

	select s.supplierid,st.description,c.name as communityname,coalesce(cg.name,'n/a') as communitygroupname
                ,coalesce(cu.firstname,'n/a') as customername,dateapplied,amount,balance,cur.currencyid,cur.isocode as currencyname
        from suppliercommunitytransactionhistory st inner join community c on st.communityid=c.communityid
			inner join currency cur on cur.currencyid=c.currencyid inner join supplier s on s.supplierid=st.supplierid
            left join communitygroup cg on st.communitygroupid=cg.communitygroupid left join customer cu on st.customerid=cu.customerid
        where (date(st.dateapplied)>=date(in_fromdate) or in_fromdate is null) 
			and (date(st.dateapplied)<=date(in_todate) or in_todate is null)
        order by s.supplierid,st.dateapplied desc ;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliernoteupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliernoteupdate`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_notetext text
)
begin
-- -------------comment-------------------------------------------
-- 1. check if a record already exists for the given supplier-customer-community-community group relationship in the suppliercustomernote table 
--      and retieve the suppliercustomernote.suppliercustomernoteid if it does
-- 2. if the returned suppliercustomernoteid is not null, update the existing record (suppliercustomernote.suppliercustomernoteid) with the updated 
--      supplier note text (suppliercustomernote.suppliernote)
-- 3. if the returned suppliercustomernoteid is null, create a new record for the given supplier-customer-community-community group relationship in 
--      the suppliercustomernote table, populating the supplier note field (suppliercustomernote.suppliernote)
-- ---------------------------------------------------------------

    if (exists(select suppliercustomernoteid from suppliercustomernote where customerid=in_customerid and supplierid=in_supplierid 
                and communityid=in_communityid and communitygroupid=in_communitygroupid)) then
       
        update suppliercustomernote set suppliernote=in_notetext where customerid=in_customerid and supplierid=in_supplierid
            and communityid=in_communityid and communitygroupid=in_communitygroupid;
    else
        insert into suppliercustomernote(customerid,communityid,communitygroupid,supplierid,suppliernote) 
            values(in_customerid,in_communityid,in_communitygroupid,in_supplierid,in_notetext);
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierparentactionselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierparentactionselect`(
in in_supplieractionid int
)
BEGIN

		select sa.supplieractionid,sa.customerid,supplierid,sa.communityid,communitygroupid,sa.actionid,actiondate,detail,responseactionperformed,parentsupplieractionid
			,c.currencyid,isocode as currencyname,concat(cus.firstname,' ',cus.lastname,' (',cus.handle,')') as customername,a.name as actionname,cc.message
			,atch.CustomerSupplierActionAttachmentID,atch.filename
			from supplieraction sa inner join community c on sa.communityid=c.communityid 
			inner join currency cu on c.currencyid=cu.currencyid
			inner join actions a on sa.actionid=a.actionid 
			inner join customer cus on cus.customerid=sa.customerid
			left join customersuppliercommunication cc on cc.supplieractionid=sa.supplieractionid
			left join customersupplieractionattachment atch on atch.CustomerSupplierActionAttachmentID=sa.supplieractionid
			where sa.supplieractionid=(select parentsupplieractionid from supplieraction where supplieractionid=in_supplieractionid);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierreviewcountbycommunitygroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierreviewcountbycommunitygroup`(
in in_communityid int,
in in_communitygroupid int,
in in_supplierid int,
in in_ownerid int,
in in_loggedinsupplierid int
)
BEGIN
-- ----------------------comment---------------------------------
-- get supplier review count by communitygroup
-- Revision : 01-07-2014 , The star rating was calculated using average function instead of sum (Refer Page: 125 , # Stars : the average star rating, )
-- --------------------------------------------------------------

		 select communityid,communitygroupid, concat(communityname,' - ',communitygroupname,' (',round(star,1), ' star(s) from ',reviews,' review(s) - ',pending,' pending)') as menu from
        (
         select c.communityid,c.name as communityname,cg.name as communitygroupname,cgs.communitygroupid,count(r.reviewid) as reviews
                ,coalesce(avg(rating),0) as star
		,coalesce((select count(reviewid) from review where reviewid not in
					(select rr.reviewid from reviewresponse rr inner join review r  on rr.reviewid=r.reviewid where supplierid=in_supplierid and communitygroupid=cg.communitygroupid)
				and supplierid=in_supplierid and communitygroupid=cg.communitygroupid  ),0) as pending
        from communitygroupsupplier cgs left join review r on cgs.SupplierID=r.supplierid and cgs.communitygroupid =r.CommunityGroupID
		inner join communitygroup cg on cgs.communitygroupid=cg.communitygroupid 
        inner join community c on cg.communityid=c.communityid
		-- inner join communitygroupsupplier cgs1 on cgs1.CommunityGroupID=cg.CommunityGroupID and (cgs1.SupplierID=in_loggedinsupplierid or in_loggedinsupplierid=0)

        where cgs.supplierid=in_supplierid and c.communityid=in_communityid and cg.communitygroupid=in_communitygroupid 
				and (c.ownerid=in_ownerid or in_ownerid=0)
		group by cgs.communitygroupid order by pending desc
        ) as tbl;
        
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierreviewpendingcountbycommunitygroupid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierreviewpendingcountbycommunitygroupid`(
in in_supplierid int,
in in_communitygroupid int
)
BEGIN
-- ----------------comment -------------------------------------------------
-- get supplier community group review pending count
-- --------------------------------------------------------------------------

		select count(reviewid) as pendingcount from review 
		where reviewid not in(select rr.reviewid from reviewresponse rr inner join review r  on rr.reviewid=r.reviewid where supplierid=in_supplierid and communitygroupid=in_communitygroupid)
		and supplierid=in_supplierid and communitygroupid=in_communitygroupid;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierreviewselect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierreviewselect`(
in in_ownerid int,
in in_communityid int,
in in_communitygroupid int,
in in_supplierid int,
in in_customerid int

)
begin
-- ---------------------commnet--------------------------------

-- ------------------------------------------------------------

        select companyname from supplier where supplierid=in_supplierid;
        
        select r.supplierid,r.reviewid,rating,review,reviewdate,hidereview,handle,c.customerid,co.name as communityname,cg.name as communitygroupname
        ,(select count(reviewid) from reviewresponse where reviewid=r.reviewid) as responsecount 
        ,response,responsedate,hideresponse,co.ownerid,r.supplieractionid

        from review r inner join customer c on r.customerid=c.customerid
         left join reviewresponse rr on rr.reviewid=r.reviewid
         left join community co on co.communityid =r.communityid
         left join communitygroup cg on cg.communitygroupid=r.communitygroupid and cg.communityid=co.communityid

        where (r.communityid=in_communityid or in_communityid=0) and (r.communitygroupid=in_communitygroupid or in_communitygroupid=0) 
        and supplierid=in_supplierid and (r.customerid=in_customerid or in_customerid=0)
        and( (ownerid=in_ownerid ) or in_ownerid=0);
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierreviewselectbysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierreviewselectbysupplier`(
in in_ownerid int,
in in_communityid int,
in in_communitygroupid int,
in in_supplierid int,
in in_customerid int,
in in_loggedinsupplierid int
)
BEGIN
-- ------------------comment------------------------------------
-- get supplier reviews based on loggedin supplier community
-- --------------------------------------------------------------
		
		 select companyname from supplier where supplierid=in_supplierid;
        
        select r.supplierid,r.reviewid,rating,review,reviewdate,hidereview,handle,c.customerid,co.name as communityname,cg.name as communitygroupname
        ,(select count(reviewid) from reviewresponse where reviewid=r.reviewid) as responsecount 
        ,response,responsedate,hideresponse,co.ownerid,r.supplieractionid

        from review r inner join customer c on r.customerid=c.customerid
         left join reviewresponse rr on rr.reviewid=r.reviewid
         left join community co on co.communityid =r.communityid
         left join communitygroup cg on cg.communitygroupid=r.communitygroupid and cg.communityid=co.communityid
		inner join communitygroupsupplier cgs on cgs.CommunityGroupID=cg.CommunityGroupID and (cgs.SupplierID=in_loggedinsupplierid or in_loggedinsupplierid=0)

        where (r.communityid=in_communityid or in_communityid=0) and (r.communitygroupid=in_communitygroupid or in_communitygroupid=0) 
        and r.supplierid=in_supplierid and (r.customerid=in_customerid or in_customerid=0)
        and( (ownerid=in_ownerid ) or in_ownerid=0) group by r.reviewid;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliersearch` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliersearch`(
in in_searchterm varchar(50),
in in_communityid int,
in in_communitygroupid int,
in in_filter varchar(50)
)
begin
-- -----------comment----------------------------------------
-- 1. if the filter value = "all"
--      a) retrieve all suppliers from the supplier table where they are linked to the supplied community (communitysupplier.communityid) and/or community group 
--          (communitygroupsupplier.communitygroupid) that match the wildcard search term (searchterm with "%" prepended & appended and replacing blanks)
-- 2. if the filter value = "in credit"
--      a) retrieve all suppliers from the supplier table where they are linked to the supplied community (communitysupplier.communityid) and/or community group 
--          (communitygroupsupplier.communitygroupid) that match the wildcard search term (searchterm with "%" prepended & appended and replacing blanks) 
--          and that have a current balance for the associated communityid (suppliercommunitytransactionhistory.balance) greater than equal to the defined 
--          mincredit amount (communitygroup.creditmin)
-- 3. if the filter value = "out of credit"
--      a) retrieve all suppliers from the supplier table where they are linked to the supplied community (communitysupplier.communityid) and/or community group 
--          (communitygroupsupplier.communitygroupid) that match the wildcard search term (searchterm with "%" prepended & appended and replacing blanks) and that
-- 4. if the filter value = "below min credit"
--      a) retrieve all suppliers from the supplier table where they are linked to the supplied community (communitysupplier.communityid) and/or community group 
--          (communitygroupsupplier.communitygroupid) that match the wildcard search term (searchterm with "%" prepended & appended and replacing blanks) 
--          and that have a current balance for the associated communityid (suppliercommunitytransactionhistory.balance) less than the defined mincredit amount 
--          (communitygroup.creditmin) and greater than 0.00
-- 5. return the results
-- ----------------------------------------------------------

    if(in_filter='all') then
        select sql_no_cache s.* from supplier s left join communitysupplier cs on cs.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on cgs.supplierid=s.supplierid
        where companyname like concat('%',in_searchterm,'%') and cs.communityid=in_communityid and cgs.communitygroupid=in_communitygroupid;
        
    elseif(in_filter='in credit') then
        
        select sql_no_cache s.* from supplier s left join communitysupplier cs on cs.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on cgs.supplierid=s.supplierid
            left join suppliercommunitytransactionhistory sh on sh.supplierid=s.supplierid
            left join communitygroup cg on cg.communitygroupid=cgs.communitygroupid
        where companyname like concat('%',in_searchterm,'%') and cs.communityid=in_communityid and cg.communitygroupid=in_communitygroupid
        and sh.balance>=cg.creditmin;
       
     elseif(in_filter='out of credit') then
        
        select sql_no_cache s.* from supplier s left join communitysupplier cs on cs.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on cgs.supplierid=s.supplierid
            left join suppliercommunitytransactionhistory sh on sh.supplierid=s.supplierid
            -- left join communitygroup cg on cg.communitygroupid=cgs.communitygroupid
        where companyname like concat('%',in_searchterm,'%') and cs.communityid=in_communityid and cgs.communitygroupid=in_communitygroupid
        and sh.balance=0;
        
     elseif(in_filter='below min credit') then
        
        select sql_no_cache s.* from supplier s left join communitysupplier cs on cs.supplierid=s.supplierid 
            left join communitygroupsupplier cgs on cgs.supplierid=s.supplierid
            left join suppliercommunitytransactionhistory sh on sh.supplierid=s.supplierid
            left join communitygroup cg on cg.communitygroupid=cgs.communitygroupid
        where companyname like concat('%',in_searchterm,'%') and cs.communityid=in_communityid and cg.communitygroupid=in_communitygroupid
        and sh.balance<cg.creditmin and sh.balance>0;    
    
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplierselect`(
in in_supplierid int
)
begin
-- ------------comment------------------------------------
-- 1. retrieve the details of the given supplierid from the supplier table (supplier.supplierid)
-- 2. return the results
-- -------------------------------------------------------

    select supplierid,companyname,email,website,primaryphone,otherphone,addressline1,addressline2,addresscity,addressstate
            ,addresspostalcode,addresscountryid,billingname,billingaddressline1,billingaddressline2,billingaddresscity,billingaddressstate
            ,billingaddresspostalcode,billingaddresscountryid,businessnumber,longitude,latitude,dateadded,profilecompleteddate,quoteterms,depositpercent,depositterms
            ,c1.countryname as addresscountryname,c2.countryname as billingaddresscountryname
    from supplier s left join country c1 on s.addresscountryid=c1.countryid
            left join country c2 on s.billingaddresscountryid=c2.countryid 
    where supplierid=in_supplierid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierselectall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `supplierselectall`()
BEGIN
-- ------------comment-------------------------------------
-- Get all supplier
-- --------------------------------------------------------

        select supplierid,companyname,dateadded from supplier;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliersocialreferencedelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliersocialreferencedelete`(
in in_suppliersocialreferenceid int
)
begin
-- -------------comment-------------------------------------------------
-- 1. remove the given supplier's social reference (suppliersocialreference)
-- ---------------------------------------------------------------------

    delete from suppliersocialreference where suppliersocialreferenceid=in_suppliersocialreferenceid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliersocialreferenceinsert` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliersocialreferenceinsert`(
in in_supplierid int,
in in_socialmediaid int,
in in_socialmediareference varchar(200)
)
begin
-- -------------comment-------------------------------------------------
-- 1. insert a new social reference for the given supplier with the given details (suppliersocialreference)
-- ---------------------------------------------------------------------

    insert into suppliersocialreference(supplierid,socialmediaid,socialmediareference)
    values(in_supplierid,in_socialmediaid,in_socialmediareference);
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliersocialreferenceselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliersocialreferenceselect`(
in in_supplierid int
)
begin
-- ------------comment------------------------------------
--  retrieve the details of the given supplierid from the suppliersocialreference
-- -------------------------------------------------------

    select sr.suppliersocialreferenceid, sm.socialmediaid, sm.name as socialmedianame, sr.socialmediareference from suppliersocialreference sr
    inner join socialmedia sm on sr.socialmediaid = sm.socialmediaid
    where supplierid = in_supplierid;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliersocialreferenceselectbysocialmedia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliersocialreferenceselectbysocialmedia`(
in in_supplierid int,
in in_mediaid int
)
BEGIN
-- -----------------comment------------------------------------------
-- get supplier social refererence by supplier and media
-- ------------------------------------------------------------------

        select suppliersocialreferenceid,supplierid,socialmediaid,socialmediareference from suppliersocialreference
        where supplierid=in_supplierid and socialmediaid=in_mediaid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliersocialreferenceupdate` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppliersocialreferenceupdate`(
in in_suppliersocialreferenceid int,
in in_supplierid int,
in in_socialmediaid int,
in in_socialmediareference varchar(200)
)
begin
-- -------------comment---------------------------------------------
-- 1. updates an existing social reference record for a supplier with the given details (suppliersocialreference)
-- -----------------------------------------------------------------

    update suppliersocialreference set supplierid=in_supplierid,socialmediaid=in_socialmediaid,socialmediareference=in_socialmediareference
    where suppliersocialreferenceid=in_suppliersocialreferenceid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `suppliertransactionsearch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `suppliertransactionsearch`(
in in_ownerid int,
in in_suppliername varchar(50),
in in_communityid int,
in in_communitygroupid int,
in in_category int,
in in_rowindex int,
in in_rowcount int
)
BEGIN
-- ----------------Comment----------------------------------------------------------------------------------------
-- Used to view the supplier and the revenue generated by them for a community owner
-- ---------------------------------------------------------------------------------------------------------------

drop table if exists tmpsupplierlist; 
create temporary table tmpsupplierlist(supplierid int,suppliername varchar(50) , ownerid int , currencyid int, communityid int, communitygroupid int,  creditmin decimal(10,2) 
, communityname varchar(50), communitygroupname varchar(50), communityactive bit, communitygroupactive bit    );

insert into tmpsupplierlist(supplierid,suppliername, ownerid, currencyid, communityid, communitygroupid,  creditmin, communityname, communitygroupname, communityactive, communitygroupactive)
select s.supplierid, s.companyname , cg.ownerid, cg.currencyid , cg.communityid, cgs.communitygroupid, cg.creditmin , cg.communityname
, cg.communitygroupname ,cg.communityactive,cg.communitygroupactive 
from vw_communitygroup cg 
inner join communitysupplier cs on cs.communityid = cg.communityid and cs.isactive =1 
inner join supplier s on cs.supplierid = s.supplierid 
left join communitygroupsupplier cgs on cgs.supplierid = s.supplierid and cgs.communitygroupid =cg.communitygroupid and cgs.isactive =1 
left join vw_suppliercommunitybalance b on cs.communityid = b.communityid and cs.supplierid = b.supplierid  
where cg.ownerid=in_ownerid and
	-- (match(s.companyname) against(in_suppliername in boolean mode) or in_suppliername='')
	s.companyname like concat('%' , in_suppliername , '%')
	and (cs.communityid=in_communityid or in_communityid=0)
	and (coalesce(cgs.communitygroupid,0)=in_communitygroupid or in_communitygroupid=0)
and 
(
 -- All suppliers 
in_category =  0
-- In Credit  Supplier 
or (in_category = 1 and b.balance > coalesce(cg.creditmin,0))
-- Out of Credit  Supplier 
or (in_category = 2 and b.balance <= 0)
-- In Credit  Supplier 
or (in_category = 3 and b.balance <=  coalesce(cg.creditmin,0) and b.balance > 0 )
	

)
-- group by s.supplierid order by s.companyname ;
;

-- Select * from tmpsupplierlist;
Select s.ownerid,  s.supplierid , s.suppliername as companyname, s.currencyid , 
    cu.isocode as currencyname ,
 coalesce((select 
                    avg(rating)
                from
                    review
                where
                    supplierid = s.supplierid and communityid =  s.communityid
                        ),
            0) as avgRating,

 coalesce((select 
                    count(reviewid)
                from
                    review
                where
                    supplierid = s.supplierid
                        and communityid = s.communityid),
            0) as reviewcount,

 coalesce((select 
                    sum(th.amount)
                from
                    communityownertransactionhistory th
                        inner join
                    billingreference b ON b.communityownertransactionhistoryid = th.communityownertransactionhistoryid
                        inner join
                    suppliercommunitytransactionhistory sth ON sth.suppliercommunitytransactionhistoryid = b.suppliercommunitytransactionhistoryid
                where
                    sth.supplierid = s.supplierid
                        and sth.communityid = s.communityid
                        and th.amount > 0),
            0) as totalrevenue,
coalesce((select 
                    sum(sth.amount)
                from
                    suppliercommunitytransactionhistory sth
                where
                    sth.supplierid = s.supplierid
                        and sth.communityid = s.communityid
                        and sth.amount > 0
                        and customerid is not null),
            0) as totalincome 
 from tmpsupplierlist s 
inner join currency cu ON cu.currencyid = s.currencyid
group by supplierid , currencyid
-- limit in_rowindex,in_rowcount;
;
-- Get summary of each supplier (overall rating , revenue and supplier income) 


 
SELECT FOUND_ROWS() as totalrecords;





select

 s.communityname,
    s.supplierid,
    s.communityid,
    cu.currencyid,
    cu.isocode as currencyname ,
-- credit : Total amount supplier top up for this community 
    coalesce((select 
                    sum(amount)
                from
                    suppliercommunitytransactionhistory
                where
                    supplierid = s.supplierid
                        and communityid = s.communityid
                        and amount > 0
                        and customerid is null),
            0) as credit,

-- revenue : owner revenue by the supplier 
    coalesce((select 
                    sum(th.amount)
                from
                    communityownertransactionhistory th
                        inner join
                    billingreference b ON b.communityownertransactionhistoryid = th.communityownertransactionhistoryid
                        inner join
                    suppliercommunitytransactionhistory sth ON sth.suppliercommunitytransactionhistoryid = b.suppliercommunitytransactionhistoryid
                where
                    sth.supplierid = s.supplierid
                        and sth.communityid = s.communityid
                        and th.amount > 0),
            0) as totalrevenue, 
coalesce((select 
                    sum(sth.amount)
                from
                    suppliercommunitytransactionhistory sth
                where
                    sth.supplierid = s.supplierid
                        and sth.communityid = s.communityid
                        and sth.amount > 0
                        and customerid is not null),
            0) as totalincome
 from tmpsupplierlist s 
inner join currency cu ON cu.currencyid = s.currencyid
 
group by supplierid , communityid
;


select  s.communitygroupname as communitygroupname,
    s.supplierid,
    s.communityid,
    s.communitygroupid,
    cu.currencyid,
    cu.isocode as currencyname,
 coalesce((select 
                    avg(rating)
                from
                    review
                where
                    supplierid = s.supplierid
                        and communitygroupid = s.communitygroupid),
            0) as avgrating,

 coalesce((select 
                    count(reviewid)
                from
                    review
                where
                    supplierid = s.supplierid
                        and communitygroupid = s.communitygroupid),
            0) as reviewcount,

coalesce((select 
                    sum(th.amount)
                from
                    communityownertransactionhistory th
                        inner join
                    billingreference b ON b.communityownertransactionhistoryid = th.communityownertransactionhistoryid
                        inner join
                    suppliercommunitytransactionhistory sth ON sth.suppliercommunitytransactionhistoryid = b.suppliercommunitytransactionhistoryid
                where
                    th.amount > 0
                        and sth.supplierid = s.supplierid
                        and sth.communitygroupid = s.communitygroupid),
            0) as totalrevenue,
-- total transaction : number of transaction made between supplier and customer     
    coalesce((select 
                    count(sth.amount)
                from
                    suppliercommunitytransactionhistory sth
                where
                    sth.supplierid = s.supplierid
                        and sth.communityid = s.communityid
                        and communitygroupid = s.communitygroupid
                        and sth.amount > 0
                        and customerid is not null),
            0) as totaltransaction,

       coalesce((select sum(sth.amount) from suppliercommunitytransactionhistory sth  
                where  sth.supplierid=s.supplierid and sth.communityid=s.communityid  and communitygroupid=s.communitygroupid and  sth.amount>0 and customerid is not null),0) as totalincome
 
  ,  (select 
            count(supplierid)
        from
            supplieraction sa
                inner join
            actions a ON sa.actionid = a.actionid
        where
            supplierid = s.supplierid
                and communityid = s.communityid
                and communitygroupid = s.communitygroupid
                and name = 'view') as viewscount

from  tmpsupplierlist s 
inner join currency cu ON cu.currencyid = s.currencyid
 where s.communitygroupid is not null
group by supplierid , communitygroupid
;


       drop table if exists tmpsupplier;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplierupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplierupdate`(
in in_supplierid int,
in in_companyname varchar(50),
in in_email varchar(200),
in in_businessnumber varchar(50),
in in_primaryphone varchar(50),
in in_otherphone varchar(50),
in in_dateadded datetime,
in in_website varchar(200),
in in_addressline1 varchar(150),
in in_addressline2 varchar(150),
in in_addresscity varchar(50),
in in_addressstate varchar(50),
in in_addresspostalcode varchar(50),
in in_addresscountryid int,
in in_billingname varchar(150),
in in_billingaddressline1 varchar(150),
in in_billingaddressline2 varchar(150),
in in_billingaddresscity varchar(50),
in in_billingaddressstate varchar(50),
in in_billingaddresspostalcode varchar(50),
in in_billingaddresscountryid varchar(50),
in in_longitude decimal(10,4),
in in_latitude decimal(10,4),
in in_profilecompleteddate datetime,
in in_quoteterms varchar(250),
in in_depositpercent decimal(10,2),
in in_depositterms varchar(250),
in in_addresscountryname varchar(100),
in in_billingcountryname varchar(100)
)
begin
-- -----------comment-----------------------------------------
-- 1. update an existing supplier record (supplier.supplierid) with the supplied details (supplier)
-- -----------------------------------------------------------

	declare v_countryid int;
	declare v_billingcountryid int;

		set v_countryid=0;
		set v_billingcountryid=0;

		if(in_addresscountryname='') then
			set v_countryid=null;
		else
			select coalesce(countryid,0) into v_countryid from country where countryname=in_addresscountryname;
			if(v_countryid=0) then
				insert into country(countryname) values(in_addresscountryname);
				set v_countryid=(select last_insert_id());
			end if;
		end if;

		if(in_billingcountryname='') then
			set v_billingcountryid=null;
		else
			select coalesce(countryid,0) into v_billingcountryid from country where countryname=in_billingcountryname;
			if(v_billingcountryid=0) then
				insert into country(countryname) values(in_billingcountryname);
				set v_billingcountryid=(select last_insert_id());
			end if;
		end if;

    update supplier set companyname=in_companyname,email=in_email,businessnumber=in_businessnumber
        ,primaryphone=in_primaryphone,otherphone=in_otherphone,dateadded=in_dateadded,website=in_website,addressline1=in_addressline1
        ,addressline2=in_addressline2,addresscity=in_addresscity,addressstate=in_addressstate,addresspostalcode=in_addresspostalcode
        ,addresscountryid=v_countryid,billingname=in_billingname,billingaddressline1=in_billingaddressline1,billingaddressline2=in_billingaddressline2
        ,billingaddresscity=in_billingaddresscity,billingaddressstate=in_billingaddressstate,billingaddresspostalcode=in_billingaddresspostalcode
        ,billingaddresscountryid=v_billingcountryid,longitude=in_longitude,latitude=in_latitude,profilecompleteddate=in_profilecompleteddate
        ,quoteterms=in_quoteterms,depositpercent=in_depositpercent,depositterms=in_depositterms
    where supplierid=in_supplierid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `transactioninsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `transactioninsert`(
in in_customerid int,
in in_supplierid int,
in in_communityid int,
in in_communitygroupid int,
in in_description varchar(200),
in in_amount decimal(10,2),
in in_dateapplied datetime,
in in_actionid int,
in in_communityownerid int
)
BEGIN
-- --------------comment------------------------
-- 1. Triggers the ActionInsert procedure to handle any action responses as a result of this transaction - 
-- 		(NB: The ActionAmount is the supplied Amount, and the ActionDetail is "Customer Transaction")
-- 2. Triggers the CreditVirtualCommunityAccount procedure to insert the transacted amount into the supplier's virtual community account
-- ---------------------------------------------

		call actioninsert(in_communityid, in_communitygroupid,in_actionid, in_communityownerid, in_supplierid ,in_customerid, 'Customer Transaction', in_amount,null,@supplieractionid);

		call creditvirtualcommunityaccount(in_supplierid,'supplier',in_communityid,in_communitygroupid,'Customer Transaction',in_amount,in_dateapplied,in_customerid);
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `transactionselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `transactionselect`(
in in_transactionhistoryid int,
in in_entity varchar(50)
)
begin
-- ------comment---------------------------------------------
-- 1. the supplied entity is "community owner"
--      a) retrieve the transaction record for the supplied transactionhistoryid for the given community owner - community 
--          (communityownertransactionhistory.communityownertransactionhistoryid)
-- 2. the supplied entity is "supplier"
--      a) retrieve the transaction record for the supplied transactionhistoryid for the given supplier - community 
--          (suppliercommunitytransactionhistory.suppliercommunitytransactionhistoryid)
-- 3. return the results
-- ----------------------------------------------------------

    if(in_entity='community owner') then
        select sql_no_cache communityownertransactionhistoryid,ownerid,communityid,communitygroupid,description,amount,dateapplied,balance
        from communityownertransactionhistory where communityownertransactionhistoryid=in_transactionhistoryid;
    
    elseif(in_entity='supplier') then
        select sql_no_cache suppliercommunitytransactionhistoryid,supplierid,communityid,communitygroupid,description,amount,dateapplied,balance,customerid
        from suppliercommunitytransactionhistory where suppliercommunitytransactionhistoryid=in_transactionhistoryid;
        
    end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `triggeredeventinsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `triggeredeventinsert`(
in in_actionname varchar(50),
in in_actionresponse int,
in in_billingpercentageadministrator decimal(10,2),
in in_billingpercentageowner decimal(10,2),
in in_isactive bit,
in in_ispercentfee bit
)
begin
-- -----------comment-------------------------------------------
-- 1. create a new action record from the supplied actionname and actionresponse and receive the returned actionid
-- 2. creatae a new triggered event record from the returned actionid and the supplied data (triggeredevent) - (nb: newly created records will have a recver of 1).
-- -------------------------------------------------------------

    declare id int;
    declare exit handler for sqlexception
    begin
        -- error
      resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
     resignal;
     rollback;
    end;

    start transaction;

    insert into actions(name) values(in_actionname);
    
    set id=(select last_insert_id());

	if(in_actionresponse!=0) then
		insert into actionresponse(actionid,responseid) values(id,in_actionresponse);
     end if;   

    insert into triggeredevent(actionid,recver,billingpercentageadministrator,billingpercentageowner,isactive,ispercentfee)
    values(id,1,in_billingpercentageadministrator,in_billingpercentageowner,in_isactive,in_ispercentfee);
   
     commit;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `triggeredeventselectall` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `triggeredeventselectall`()
BEGIN
-- --------------------------comment-----------------------------
-- Get all triggered events
-- --------------------------------------------------------------

        select a.name as actionname,a.actionid,te.triggeredeventid,billingpercentageadministrator,billingpercentageowner,isactive,IsPercentFee
        from actions a inner join triggeredevent te on te.actionid=a.actionid;
   
        
        select ar.responseid,ar.actionid,actionresponseid from actions a inner join actionresponse ar on ar.actionid=a.actionid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `triggeredeventupdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `triggeredeventupdate`(
in in_actionid int,
in in_recver int,
in in_billingpercentageadministrator decimal(10,2),
in in_billingpercentageowner decimal(10,2),
in in_isactive bit,
in in_ispercentfee bit,
in in_response varchar(50)
)
begin
-- ------------comment-----------------------------------------
-- 1. update the action record (actions) with the supplied action response (actions.actionresponse)
-- 2. update the existing triggered event record (triggeredevent.triggeredeventid) with the supplied details (triggeredevent)
-- ------------------------------------------------------------

    declare exit handler for sqlexception
    begin
        -- error
      resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
     resignal;
     rollback;
    end;

    start transaction;
    
               
        update triggeredevent set recver=in_recver,billingpercentageadministrator=in_billingpercentageadministrator
            ,billingpercentageowner=in_billingpercentageowner,isactive=in_isactive,ispercentfee=in_ispercentfee 
        where actionid=in_actionid;
        
        delete from actionresponse where actionid=in_actionid;
        
        if(in_response!='') then
        
        SELECT LENGTH(in_response) - LENGTH(REPLACE(in_response, ',', '')) into @Valcount;
        SET @v1=0;
        
        WHILE (@v1 <= @Valcount) DO
            -- set @val = stringSplit(in_response,',',@v1+1);

			set @val = REPLACE(SUBSTRING(SUBSTRING_INDEX(in_response, ',', @v1+1),LENGTH(SUBSTRING_INDEX(in_response, ',', (@v1+1) -1)) + 1), ',', '');

            insert into actionresponse(actionid,responseid) values(in_actionid,@val);
            SET @v1 = @v1 + 1;
        END WHILE;
        
        end if;

    commit;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_communitydelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_communitydelete`(
in in_communityid int
)
begin
-- --------comment------------------------------------------
-- delete community from table (unit test purpose)
-- ---------------------------------------------------------

    delete from community where communityid=in_communityid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_communitygroupdelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_communitygroupdelete`(
in in_communitygroupid int
)
begin
-- -------------------comment------------------------------------
-- delete community group from table (unit test purpose)
-- --------------------------------------------------------------
    
    delete from communitygroup where communitygroupid=in_communitygroupid;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_customerdelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_customerdelete`(
in in_customerid int
)
begin
-- --------comment-------------------------------------------
-- delete customer information from tabel(customer) based on customerid (unit test purpose)
-- ----------------------------------------------------------

    delete from customer where customerid=in_customerid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_deletecurrency` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_deletecurrency`(
in in_currencyid int
)
begin
-- -------------------comment------------------------------
-- delete currency from tabel 
-- --------------------------------------------------------

    delete from currency where currencyid=in_currencyid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_getcurrency` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_getcurrency`(
in in_currencyid int
)
begin
-- ---------comment--------------------------------------
-- get currency information based on currencyid
-- -------------------------------------------------------

    select currencyid,isocode,description,mintransferamount,isactive from currency where currencyid=in_currencyid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_oauthaccountdelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `ut_oauthaccountdelete`(
in in_oauthaccountid int
)
BEGIN
-- ---------------comment-------------------
-- delete oauthaccount related table (unit test purpose)
-- -----------------------------------------

		delete from usersecurity where oauthaccountid=in_oauthaccountid;
		delete from entityoauthaccount where oauthaccountid=in_oauthaccountid;
		delete from oauthaccount where oauthaccountid=in_oauthaccountid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_ownerdelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_ownerdelete`(
in in_ownerid int
)
begin
-- ---------comment-----------------------------------------
-- delete supplier from tabel (unit test purpose)
-- ---------------------------------------------------------
    
    declare exit handler for sqlexception
      begin
        -- error
        resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
        resignal;
     rollback;
    end;
    
    start transaction;
    
    delete from entityoauthaccount where entitytype='communityowner' and entityid=in_ownerid;
    
    delete from owner where ownerid=in_ownerid;
    
    commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_ownerselect` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_ownerselect`(
in in_ownerid int
)
begin
-- -------------comment-----------------------------------
-- get owner information based on ownerid (unit test purpose)
-- -------------------------------------------------------

    select * from owner where ownerid=in_ownerid;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_reviewdelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_reviewdelete`(
in in_reviewid int
)
begin
-- --------------------comment----------------------------
-- delete review from table (unit test purpose)
-- -------------------------------------------------------
    
    delete from review where reviewid=in_reviewid;
    

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_supplieractiondeletebysupplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `ut_supplieractiondeletebysupplier`(
in in_supplierid int
)
BEGIN
-- ----------------------comment-------------------------
-- delete suplieraction by supplierid (unit test purpose)
-- ------------------------------------------------------

		delete from supplieraction where supplierid=in_supplierid;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ut_supplierdelete` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ut_supplierdelete`(
in in_supplierid int
)
begin
-- ---------comment-----------------------------------------
-- delete supplier from tabel (unit test purpose)
-- ---------------------------------------------------------
    
    declare exit handler for sqlexception
      begin
        -- error
        resignal;
      rollback;
    end;

    declare exit handler for sqlwarning
     begin
        -- warning
        resignal;
     rollback;
    end;
    
    start transaction;
    
    delete from entityoauthaccount where entitytype='supplier' and entityid=in_supplierid;
    
    delete from supplier where supplierid=in_supplierid;
    
    commit;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `validateaccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `validateaccount`(
in oauthprovider varchar(50),
in oauthuserid varchar(200),
in oauthtoken varchar(50)
)
begin
    
      /*if(exists(select oauthaccountid from oauthaccount where provider=oauthprovider and provideruserid=oauthuserid and token=oauthtoken)) then
            select 'valid' as result;
       else
            select 'invalid' as result;
       end if;*/
       
       
       if(exists(select oauthaccountid from oauthaccount where provider=oauthprovider and provideruserid=oauthuserid and token=oauthtoken)) then           
           select 'valid' as result, a.oauthaccountid, a.active, ea.entitytype, ea.entityid,a.provideruserid  from oauthaccount a 
           left join entityoauthaccount ea on a.oauthaccountid = ea.oauthaccountid 
           where a.provider=oauthprovider and a.provideruserid=oauthuserid and a.token=oauthtoken;
           
             select 'valid' as result, a.oauthaccountid, a.active,coalesce(us.administrator,0) as administrator
             ,coalesce(us.communityowner,0) as communityowner,coalesce(us.supplier,0) as supplier,coalesce(us.customer,0) as customer,a.provideruserid 
            from oauthaccount a left join usersecurity us on us.oauthaccountid=a.oauthaccountid
             where a.provider=oauthprovider and a.provideruserid=oauthuserid and a.token=oauthtoken;
           
       else
           select 'invalid' as result;
       end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `validateapitoken` */;
ALTER DATABASE `ratingreviewengine` CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `validateapitoken`(
in in_apitoken varchar(50)
)
begin
-- -------comment-----------------------------------------
-- check given api token is valid and active, returns : valid / invalid
-- -------------------------------------------------------

  if(exists(select applicationid 
        from applicationauthentication where apitoken=in_apitoken and isactive=true)) then
            select 'valid' as result;
       else
            select 'invalid' as result;
       end if;
        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `ratingreviewengine` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-09 11:19:49
