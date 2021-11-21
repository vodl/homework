public with sharing class AccountServices {

    public static void manageChildAccounts(List<Account> newAccounts){

        List<Account> accountsToInsert = new List<Account>();
        
        for(Account acc : newAccounts){
            if(acc.ParentId == null){
                accountsToInsert.add( makeChildAccount(acc) );
            }
        }
        insert accountsToInsert;
    }

    private static Account makeChildAccount(Account parent){
        Account child = new Account();
        child.ParentId = parent.Id;
        child.Name = parent.Name + ' child';
        return child;
    }

}
