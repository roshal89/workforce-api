/**
* @description       : Class to schedule the batch WorkforceManagmtCalloutBatch for callout
* @author            : Shalini Tripathi 
* @last modified on  : 08-20-2020
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   08-20-2020   Shalini Tripathi                    Initial Version
**/
global class WorkforceManagmtCalloutSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        WorkforceManagmtCalloutBatch batchWorkforce = new WorkforceManagmtCalloutBatch(); 
        database.executebatch(batchWorkforce);
    }
}