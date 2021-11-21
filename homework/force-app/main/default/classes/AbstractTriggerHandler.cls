/**
 * @description abstract class implementing common ITriggerHander interface
 */
abstract public with sharing class AbstractTriggerHandler implements ITriggerHandler{

    public static Boolean globalSupressTriggers = false;

    //to be overriden in handler implementation 
    public virtual void afterInsert(){}
    public virtual void afterDelete(){}
    public virtual void afterUpdate(){}
    public virtual void afterUndelete(){}

    public virtual void beforeInsert(){}
    public virtual void beforeDelete(){}
    public virtual void beforeUpdate(){}

    abstract Boolean isBypassed(); //helper method so we able to check whether we need to skip trigger execution

    /**
     * @description Entry method for trigger execution - this should be called from trigger after handler instantiation
     *
     * @param operationType Enum from trigger specifing type of trigger operation
     */
    public virtual void handle(System.TriggerOperation operationType ) {
        if(this.isBypassed() || globalSupressTriggers){
            System.debug('The trigger for ' + operationType + ' was skipped');
            return;
        }

        switch on operationType {
            when AFTER_INSERT {
                afterInsert();
            }
            when AFTER_UPDATE {
                afterUpdate();
            }
            when AFTER_DELETE {
                afterDelete();
            }
            when AFTER_UNDELETE {
                afterUndelete();
            }
            when BEFORE_INSERT {
                beforeInsert();
            }
            when BEFORE_UPDATE {
                beforeUpdate();
            }
            when BEFORE_DELETE {
                beforeDelete();
            }
            when else {
                System.debug('Wrong value of operationType Trigger enum');
            }
        }
    }
}