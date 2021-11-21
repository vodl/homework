public class AppendChildForLegacyAccountsBatch implements Database.Batchable<sObject> {
  private final String query = 'SELECT Id, ParentId, Name FROM Account WHERE ParentId = null';

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<sObject> retrieved) {
      Map<Id,Account> accountMap = new Map<Id, Account>((List<Account>) retrieved);
      List<Account> childAccounts = [
          SELECT Id, Name, ParentId 
          FROM Account 
          WHERE ParentId IN :accountMap.keySet()
     ];

     Set<Id> accountsWithChildIds = new Set<Id>();
     for(Account child : childAccounts){
        accountsWithChildIds.add(child.ParentId);
     }

     List<Account> accountsMissingChildAccounts = new List<Account>();
     for(Account parent : accountMap.values()){
         if(!accountsWithChildIds.contains(parent.Id)){
            accountsMissingChildAccounts.add(parent);
         }
     }

     AccountServices.manageChildAccounts(accountsMissingChildAccounts);
  }

  public void finish(Database.BatchableContext bc) {
  }
}