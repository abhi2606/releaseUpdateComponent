public with sharing class ReleaseUpdateController {
    

    @AuraEnabled(cacheable=true)
    public static List<Release__c> getRelease(){
        // Map<Id,Release__c> releaseMap = new Map<Id,Release__c>();
        // for(Release__c rel : [SELECT Id, Name, Country__c, Description__c, Profiles__c,Release_Date__c,Title__c,External_Link__c FROM Release__c]){
        //     releaseMap.put(rel.Id,rel);
        // }

        // Map<Id, Map<Id, String>> relatedFileMap = getRelatedFiles(releaseMap.keySet());
        // Map<Release__c,Map<Id,String>> finalMap = new Map<Release__c,Map<Id,String>>();
        // for (Id recId : releaseMap.keySet()) {
        //     if(relatedFileMap.containsKey(recId)){
        //         finalMap.put(releaseMap.get(recId),relatedFileMap.get(recId));
        //     }
        //     else {
        //         finalMap.put(releaseMap.get(recId),new Map<Id,String>());
        //     }
        // }       
        // return finalMap;

        return [SELECT Id, Name, Country__c, Description__c, Profiles__c,Release_Date__c,Title__c,External_Link__c,(SELECT ContentDocumentId,ContentDocument.Title  FROM ContentDocumentLinks) FROM Release__c ];
    }


    public static Map<Id, Map<Id, String>> getRelatedFiles(Set<Id> recordIds){
        try {
            //Set<Id> recordIds = getRelease().keySet();
            Map<Id,Id> recordIdToContentIdMap = new Map<Id,Id>();
            List<ContentDocumentLink> files = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :recordIds];
            List<Id> fileIds = new List<Id>();
            for(ContentDocumentLink doc : files){
                fileIds.add(doc.ContentDocumentId);
                recordIdToContentIdMap.put(doc.ContentDocumentId,doc.LinkedEntityId);
                
            }
            Map<Id,String> contentToNameMap = new Map<Id,String>();
            List<ContentVersion> docs = [SELECT ContentDocumentId ,FileExtension,Title FROM ContentVersion WHERE ContentDocumentId IN : fileIds];
            for(ContentVersion docLink : docs){

                contentToNameMap.put(docLink.ContentDocumentId,docLink.Title);
            }

            Map<Id, Map<Id, String>> resultMap = new  Map<Id, Map<Id, String>>();
            for (Id conId : recordIdToContentIdMap.keySet()){
                Id recordId = recordIdToContentIdMap.get(conId);
                String filename = contentToNameMap.get(conId);
                if(!resultMap.containsKey(recordId)){
                    resultMap.put(recordId, new Map<Id, String>());
                }
                resultMap.get(recordId).put(conId, filename);
            }
            return resultMap; 
        }

        catch (Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}