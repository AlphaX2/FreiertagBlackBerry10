import bb.cascades 1.0

Page {
    id: result_root
    
	// property aliases to be set from main.qml, while loading this page
    property alias titleText: result_title.title
    property alias subtitleText: subtitle.text
    property alias subtitleJahr: subtitleJahr.text
    property alias holidayList: result_model
            
	titleBar: TitleBar {
	    id: result_title
	    title: "Title"
	}
    
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Zurück"
            onTriggered: { navigationPane.pop(); }
        }
    }
    
    Container {
        id: content
        
        bottomPadding: 20
        
        Container {  
            rightPadding: 20
            horizontalAlignment: HorizontalAlignment.Right
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
	            id: subtitle
	            text: "Subtitle"
	        }
	        Label {
	            id: subtitleJahr
	            text: "XXXX"
	        }
	    }
	    
	    ListView {
	        id: holiday_listview
	        dataModel: ArrayDataModel{id: result_model}
	        listItemComponents: [
	            ListItemComponent {
                     Container {
                        id: myItem
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        
                         contextActions: [
                             ActionSet {
                                 title: ListItemData.name
                                 subtitle: ListItemData.date
                                 
                                 InvokeActionItem {
                                     title: "Schulferien.org öffnen"
 		                             
 		                             query {
		                                 invokeActionId: "bb.action.OPEN"
		                                 invokeTargetId: "sys.browser"
		                                 uri: "http://www.schulferien.org/iCal"
		                             }                   
                               }
                                   
// NOT WORKING AT THE MOMENT, STILL HERE FOR LATER EVALUATION!                                   
//                                   InvokeActionItem {
//                                     title: "Zum Kalender hinzufügen"
// 		                             
// 		                                 query {   		                                 
//		                                     invokeActionId: "sys.pim.calendar.viewer.ics"
//		                                     invokeTargetId: "bb.system.OPEN"
//		                                     uri: "data/2013/ferien/Ferien_Sachsen_2013.ics"
//		                                 }                   
//                                   }                                   
                               }    
                           ]
                       
                        Container {
                            topPadding: 10
	                        Header {
		                       title: ListItemData.name
		                   }
	                    }
	                    Container {
	                        leftPadding: 20
	                        topPadding: 5
	                           
	    	                Label {
		             	      text: ListItemData.date
	                          textStyle.color: Color.create("#646464")
                            }
	                    }      
	                } // end of myItem
	            } // end of ListItemComponent
	        ] // end of ListItemComponents
	    } // end of ListView	
	} // end of Container (content)
} // end of Page