/**
 * @description: interface to be implemented by all custom trigger handlers to make sure it all follows the same pattern
 */
public interface ITriggerHandler {

    void afterInsert();
    void afterDelete();
    void afterUpdate();
    void afterUndelete();

    void beforeInsert();
    void beforeDelete();
    void beforeUpdate();

    Boolean isBypassed(); //helper method so we able to check whether we need to skip trigger execution 
    void handle(System.TriggerOperation operationType); //method to be caller from trigger to execute dispatching logic
}