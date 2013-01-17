// Default empty project template
import bb.cascades 1.0
import "../tart.js" as Tart

NavigationPane {
    id: navigationPane
         Menu.definition: MenuDefinition {
               
             // Specify the actions that should be included in the menu
             actions: [
                 ActionItem {
                     title: "Über"
                     imageSource: "ic_info.png"
                         
                     onTriggered: {
                         aboutDialog.open()
                     }
                 }
             ]     
         }

    Page {
        id: main_app_page
        
		//set some standard data, for the case, nothing is selected by hand
        property string land: "Baden-Württemberg"
        property string jahr: "2013"
        property string ferien: "Schulferien"

        onCreationCompleted: {
			// init the BB-Tart stuff to allow QML->Python communication
            Tart.init(_tart, Application);
            Tart.register(main_app_page);
        }
        
		// function is called from Python
        function onGetPythonList(data) {
            var page = resultPage.createObject();
            page.titleText = main_app_page.land
            page.subtitleText = main_app_page.ferien
            page.subtitleJahr = main_app_page.jahr
            page.holidayList.clear()
            
			// fill ListViews dataModel
            var list = data.liste   
            var i = 0
            for (i=0; i<list.length; i++){
                page.holidayList.append({"name": list[i], "date": list[i+1]})
                i++
                }
            navigationPane.push(page);
            }

        actions: [
            ActionItem {
                id: searchbutton
                title: "Suche"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "ic_search.png"
                
                onTriggered: {
					/* this function send the selected things to Python, Python parses the ics file
					and send back a list with the parsed results to the "onGetPythonList()" function,
					which is populating the dataModel and opens result page. */
                    Tart.send("suche", {bundesland:main_app_page.land, jahr:main_app_page.jahr, frei:main_app_page.ferien});          
                }
            }
        ]
        
        attachedObjects: [
                Dialog {
                   id: aboutDialog
         
                   Container {
                       verticalAlignment: VerticalAlignment.Center
                       horizontalAlignment: HorizontalAlignment.Center
                       preferredWidth: 768
                       preferredHeight: 1280
                        
                       background: Color.create (0.0, 0.0, 0.0, 0.8)

                        Label {
                           id: infoTitle
                           text: "Über Freiertag"
                           textStyle.fontSize: FontSize.XLarge
                           horizontalAlignment: HorizontalAlignment.Center
                           textStyle.fontWeight: FontWeight.W100
                           textStyle.color: Color.LightGray
                           }
                       
                        Label {
                           id: infoText
                           text: "Mit Freiertag können die Schulferien, \nals auch die Feiertage aller deutschen \nBundesländer abgefragt werden. \nDer SourceCode der Anwendung wird \nunter den Bedingungeen der GPL3 \nLizenz veröffentlicht. \n\nAutor: \nGabriel Böhme \n\nE-Mail: \nm.gabrielboehme@googlemail.com\n \nDatenquelle:\nwww.schulferien.org/iCal/"
                           textStyle.textAlign: TextAlign.Center
                           horizontalAlignment: HorizontalAlignment.Center                           
                           multiline: true
                           topMargin: 25
                           textStyle.color: Color.LightGray
                           }
                       
                        Button {
                           horizontalAlignment: HorizontalAlignment.Center
                           text: "Okay"
                           topMargin: 30
                           onClicked: aboutDialog.close()
                           }
                   }
               },
               ComponentDefinition {
                   id: resultPage;
                   source: "results.qml"
               }
           ]

        titleBar: TitleBar {
                id: main_title
                title : "Freiertag"
            }

        Container {            
            Container {
                id: bundeslandDivider
                
                topMargin: 20
                rightPadding: 20
                
                layout: StackLayout {
                    orientation: LayoutOrientation.RightToLeft
                }
                Label {
	                text: "Bundesland"
	                textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.create("#0098f0")
                }
	            Divider {
                    verticalAlignment: VerticalAlignment.Center
                }
	        }
	        
	        ////////// bundesland selection //////////
	        
            DropDown {
                id: bundeslandAuswahl
                title: "Bundesland"
                maxWidth: 700
                horizontalAlignment: HorizontalAlignment.Center
                selectedIndex: 0
				
				/* 	to set the selected option, it could be also possible to
					use DropDown's onSelectedItemChanged function */ 
				
                Option {
                    id: land_bw
                    text: "Baden-Württemberg"
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_bw.text
                        }    
                    }
                }
                Option {
                    id: land_by
                    text: "Bayern" 
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_by.text
                        }
                    }                                
                }
                Option {
                    id: land_b
                    text: "Berlin"
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_b.text
                        }
                    }                                       
                }
                Option {
                    id: land_bb
                    text: "Brandenburg"
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_bb.text
                        }
                    }                                      
                }
                Option {
                    id: land_br
                    text: "Bremen"
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_br.text
                        }
                    }                                    
                }
                Option {
                    id: land_hh
                    text: "Hamburg"
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_hh.text
                        }
                    }                                      
                }
                Option {
                    id: land_he
                    text: "Hessen"
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_he.text
                        }
                    }                   
                }
                Option {
                    id: land_mv
                    text: "Mecklenburg Vorpommern" 
                    onSelectedChanged: {
                        if (selected == true) {
                        main_app_page.land = land_mv.text
                        }
                    }                    
                }
                Option {
                    id: land_ns
                    text: "Niedersachsen"
                    onSelectedChanged: {
                       if (selected == true) { 
                        main_app_page.land = land_mv.text
                        }
                    }                                     
                }
                Option {
                    id: land_nrw
                    text: "Nordrhein Westfalen"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_nrw.text
                        }
                    }                                       
                }
                Option {
                    id: land_rp
                    text: "Rheinland Pfalz"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_rp.text
                        }
                    }                                     
                }
                Option {
                    id: land_sl
                    text: "Saarland"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_sl.text
                        }
                    }                                     
                }
                Option {
                    id: land_sa
                    text: "Sachsen"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_sa.text
                        }
                    }                                        
                }
                Option {
                    id: land_saa
                    text: "Sachsen Anhalt"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_saa.text
                        }
                    }                                     
                }
                Option {
                    id: land_sh
                    text: "Schleswig Holstein"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_sh.text
                        }
                    }                                      
                }
                Option {
                    id: land_th
                    text: "Thüringen"
                    onSelectedChanged: {
                        if (selected == true) { 
                        main_app_page.land = land_th.text
                        }
                    }                                     
                }                                                               
            }
            
            Container {
                id: jahrDivider
                rightPadding: 20
                
                layout: StackLayout {
                    orientation: LayoutOrientation.RightToLeft
                }
                
                Label {
	                text: "Jahr"
	                textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.create("#0098f0")
                }
	            Divider {
                    verticalAlignment: VerticalAlignment.Center
                }
	        }   
	        
	        ////////// jahr selection //////////
	        
            DropDown {
                id: jahrAuswahl
                title: "Jahr"
                maxWidth: 700
                horizontalAlignment: HorizontalAlignment.Center
                
                selectedIndex: 0
                
                Option {
                    id: year_one
                    text: "2013"
                    onSelectedChanged: {
                        if (selected == true) { 
                            main_app_page.jahr = year_one.text
                        }
                    }  
                }
                Option {
                    id: year_two
                    text: "2014"
                    onSelectedChanged: {
                        if (selected == true) { 
                            main_app_page.jahr = year_two.text
                        }
                    }
                }
                Option {
                    id: year_three
                    text: "2015"
                    onSelectedChanged: {
                        if (selected == true) { 
                            main_app_page.jahr = year_three.text
                        }  
                    }                  
                }
            }
            
            Container {
                id: ferienDivider
                rightPadding: 20
                
                layout: StackLayout {
                    orientation: LayoutOrientation.RightToLeft
                }
                
                Label {
	                text: "Ferien"
	                textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.create("#0098f0")
                }
	            Divider {
                    verticalAlignment: VerticalAlignment.Center
                }
	        }
	        
	        ////////// ferien selection //////////
	        
	        Container {
	            maxWidth: 700
	            horizontalAlignment: HorizontalAlignment.Center
	            
	            RadioGroup {
	                id: ferienAuswahl
	                
	                selectedIndex: 0
	                
	                Option {
	                    id: ferien_schule
	                    text: "Schulferien"	
	                    onSelectedChanged: {
	                        if (selected == true) { 
	                        main_app_page.ferien = ferien_schule.text
	                        }
	                    }                  
	                }
	                Option {
	                    id: ferien_gesetz_feier
	                    text: "gesetzliche Feiertage"
	                    onSelectedChanged: {
	                        if (selected == true) { 
	                        main_app_page.ferien = ferien_gesetz_feier.text
	                        }
	                    }	                    	                    
	                }
	                Option {
	                    id: ferien_alle_feier
	                    text: "alle Feiertage"
	                    onSelectedChanged: {
	                        if (selected == true) { 
	                        main_app_page.ferien = ferien_alle_feier.text
	                        }
	                    }	                    
	                }
	            }            
            }              
        }
    }
    onPopTransitionEnded: { page.destroy(); }
}
