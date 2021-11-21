@IsTest
public with sharing class AccountServicesTest {

    @IsTest
    public static void testAddChild(){

        Account parent = new Account();
        parent.Name = 'Test Account';

        Test.startTest();
        insert parent;
        Test.stopTest();

        List<Account> childAccounts = [
            SELECT Id, Name, ParentId 
            FROM Account 
            WHERE ParentId = :parent.Id
        ];

        System.assertEquals(1, childAccounts.size(), 'Single child account should be created');
    }

    @IsTest
    public static void testAddChild_bulk(){

        final Integer RECORD_AMOUNT = 200;
        List<Account> parents = new List<Account>();

        for(Integer i = 0; i < RECORD_AMOUNT; i++){
            Account parent = new Account();
            parent.Name = 'Test Account ' + i;
            parents.add(parent);
        }

        Test.startTest();
        insert parents;
        Test.stopTest();

        Map<Id, Account> parentMap = new Map<Id, Account>(parents);

        List<Account> childAccounts = [
            SELECT Id, Name, ParentId 
            FROM Account 
            WHERE ParentId IN :parentMap.keySet()
        ];

        System.assertEquals(RECORD_AMOUNT, childAccounts.size(),
         'Single child account should be created for each new account');
    }

    @IsTest
    public static void testAppendChildForLegacyBatch(){

        final Integer RECORD_AMOUNT = 200;
        List<Account> parents = new List<Account>();

        for(Integer i = 0; i < RECORD_AMOUNT; i++){
            Account parent = new Account();
            parent.Name = 'Test Account ' + i;
            parents.add(parent);
        }

        AbstractTriggerHandler.globalSupressTriggers = true; //simulate legacy logic - do not create child acc
        insert parents;
        AbstractTriggerHandler.globalSupressTriggers = false;

        Test.startTest();
        AppendChildForLegacyAccountsBatch batch = new AppendChildForLegacyAccountsBatch();
        Database.executeBatch(batch, RECORD_AMOUNT);
        Test.stopTest();

        Map<Id, Account> parentMap = new Map<Id, Account>(parents);

        List<Account> childAccounts = [
            SELECT Id, Name, ParentId 
            FROM Account 
            WHERE ParentId IN :parentMap.keySet()
        ];

        System.assertEquals(RECORD_AMOUNT, childAccounts.size(),
         'Single child account should be created for each new account');
    }

    /**
     * @description: Check that no extra child account created where there are none missing
     */
    @IsTest
    public static void testAppendChildForLegacyBatch_noLegacy(){

        final Integer RECORD_AMOUNT = 200;
        List<Account> parents = new List<Account>();

        for(Integer i = 0; i < RECORD_AMOUNT; i++){
            Account parent = new Account();
            parent.Name = 'Test Account ' + i;
            parents.add(parent);
        }
        insert parents;

        Test.startTest();
        AppendChildForLegacyAccountsBatch batch = new AppendChildForLegacyAccountsBatch();
        Database.executeBatch(batch, RECORD_AMOUNT);
        Test.stopTest();

        Map<Id, Account> parentMap = new Map<Id, Account>(parents);

        List<Account> childAccounts = [
            SELECT Id, Name, ParentId 
            FROM Account 
            WHERE ParentId IN :parentMap.keySet()
        ];

        System.assertEquals(RECORD_AMOUNT, childAccounts.size(),
         'Single child account should be created for each new account');
    }
}
