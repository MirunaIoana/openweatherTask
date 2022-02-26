trigger AccountTrigger on Account (before insert, before update, after update, after insert) {
    AccountTriggerHandler accountHandler = new AccountTriggerHandler();
    if(trigger.isUpdate && trigger.isBefore){
        accountHandler.onUpdate(trigger.new, trigger.oldMap);
    }
    if(trigger.isInsert && trigger.isAfter){
        accountHandler.onInsert(trigger.new);
    }
}