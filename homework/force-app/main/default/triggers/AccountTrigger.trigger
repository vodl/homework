trigger AccountTrigger on Account(after insert) {
    ITriggerHandler handler = new AccountTriggerHandler(Trigger.oldMap, Trigger.new);
    handler.handle(Trigger.operationType);
}