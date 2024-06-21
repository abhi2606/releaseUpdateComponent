import { LightningElement ,wire,api} from 'lwc';
import getRelease  from '@salesforce/apex/ReleaseUpdateController.getRelease';
import ProfileName from '@salesforce/schema/User.Profile.Name';
//import getRelatedFiles from '@salesforce/apex/ReleaseUpdateController.getRelatedFiles';
import {NavigationMixin} from 'lightning/navigation';
export default class ReleaseUpdates extends NavigationMixin(LightningElement) {
    releaseNotes = [];
    error;
    filteredResult;
    @wire(getRelease)
    wiredData({data,error}) {
        if(data){
            // this.dataMap = Object.keys(data).map(key => ({
            //     Id: key,
            //     ...data[key]
            // }));
            // console.log(data);
            // //const mapp =new Map(Object.entries(data));
            // console.log(this.dataMap);
            // // this.releaseNotesId = map.keys();
            // // this.releaseNotes = map.values();

            // //this.releaseNotes = mapp.Keys;
            // this.dataMap = [];
            // for (var key in data) {
            //     let value = [];
            //     for (var innerkey in data[key]) {
            //         value.push({ key: innerkey, value: data[key][innerkey] });
            //     }
            //     this.dataMap.push({ key: key, value: value })
            //     this.releaseNotes.push(key);
            //     console.log('key', key, data[key]);
            // }
            // for(var key in data){
            //     // console.log(data[key]);
            //      console.log(data[key][value]);

            //     // console.log(data[key].Profiles__c);
            //     if(data[key].Profiles__c == 'Solution Manager'){
            //         this.releaseNotes.push({key: data[key], value:  data[key] });
            //     }
            // }
            this.releaseNotes = data;
            console.log(data);
            //console.log(this.releaseNotes);

        }
        else{
          this.error = error;
        }
    }

    handlePreview(event){
        const recordId = event.target.dataset.id;
        console.log(recordId);
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: recordId
            }
        })
    }
}