/**
 * @description Handler for Account Trigger
 */
public with sharing class AccountTriggerHandler extends AbstractTriggerHandler implements ITriggerHandler{

    Map<Id, Account> oldMap;
    List<Account> newList;
    public static Boolean isBypassed = false;


    public AccountTriggerHandler(Map<Id, Account> oldMap, List<Account> newList ) {
        this.oldMap = oldMap;
        this.newList = newList;
    }

    public Boolean isBypassed(){
        return isBypassed;
    }

    public override void afterInsert(){
        AccountServices.manageChildAccounts(newList);
    }
}