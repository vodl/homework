trigger AccountTrigger on Account(after insert, after update) {
    MAH_ITriggerHandler handler = new AccountTriggerHandler(Trigger.oldMap, Trigger.new);
    handler.handle(Trigger.operationType);
}