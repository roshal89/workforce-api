trigger CaseTrigger on Case (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        if ( !System.isFuture() ) {
            WorkManagementPlatformCallout.workMngmtPlatformUpdate( Trigger.new, Trigger.oldMap );
        }
    }
}