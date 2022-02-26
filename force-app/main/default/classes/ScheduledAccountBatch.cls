/**
 * Schedulable AccountsUpdateBatch batch
 */
global class ScheduledAccountBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      AccountsUpdateBatch batchJob = new AccountsUpdateBatch();
      
      //limit batch size to 100 because of apex callout limit (100 callouts per transaction in a batch)
      database.executeBatch(batchJob,100);
   }
}