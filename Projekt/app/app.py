#! -*- coding: utf-8 -*-

import tart
import sys
from datetime import date

# Class that holds all functions, that can be called from QML
class App(tart.Application):
	# just a function to test QML->Python communication
    def onSuche_test(self, bundesland, jahr, frei):
        print(bundesland)
        print(jahr)
        print(frei)

        tart.send('test', text="hello world")

    def onSuche(self, bundesland, jahr, frei):
        #replace special letters to fit the naming convention of the ics files
        bundesland = bundesland.replace('ü','ue')
        bundesland = bundesland.replace('-','_')
        print(bundesland)

        if frei == 'Schulferien':
            print("Schulferien erkannt")
            self.parse_ferien(jahr, bundesland)

        if frei == 'gesetzliche Feiertage':
            print("gesetzl. Feiertage erkannt")
            gesetz = True
            self.parse_feiertage(jahr, bundesland, gesetz)

        if frei == 'alle Feiertage':
            print("Feiertage allgemein erkannt")
            gesetz = False
            self.parse_feiertage(jahr,bundesland, gesetz)


    def parse_ferien(self, jahr, bundesland):
        results = []
        with open('app/native/assets/data/{0}/ferien/Ferien_{1}_{2}.ics'.format(jahr, bundesland, jahr)) as termine:
            for start_ende in termine.readlines():
                #holiday names are found at SUMMARY and is parsed here
                if start_ende.startswith('SUMMARY:'):
                    summary = start_ende[8:-1]
                    summary = summary.replace('ue', 'ü')
                    summary = summary[:len(summary)-len(bundesland)]

                    results.append(summary)

                #start and end of the holidays parsed
                if start_ende.startswith('DTSTART;VALUE=DATE:'):
                    datum_start = start_ende[19:27]
                    ds = datum_start[6:8] 
                    ms = datum_start[4:6] 
                    ys = datum_start[0:4]

                if start_ende.startswith('DTEND;VALUE=DATE:'):
                    datum_ende = start_ende[17:25]
                    de = datum_ende[6:8] 
                    me = datum_ende[4:6] 
                    ye = datum_ende[0:4]

                    datum = '{0}.{1}.{2} - {3}.{4}.{5}'.format(ds, ms, ys, de, me, ye)
                    results.append(datum)

			#Send the final list to QMLs "onGetPythonList" function via BB-Tart
            tart.send('getPythonList', liste=results)


    def parse_feiertage(self, jahr, bundesland, gesetz):
        #bestimmt die Datei, an Hand der Variablen aus den Comboboxen.
        #Die Dateien liegen dann unter data/<jahr>/feiertage/Ferien_<bundesland>_<jahr>.ics liegen, unterscheidet nach gesetzlich oder nicht!
        if gesetz == True:
            with open ('app/native/assets/data/{0}/feiertage/Feiertage_{1}_{2}.ics'.format(jahr, bundesland, jahr), 'r') as termine:
                self.parse_loop_feiertage(termine)

        elif gesetz == False:
            with open('app/native/assets/data/{0}/feiertage/Feiertage_{1}.ics'.format(jahr, jahr), 'r') as termine:
                self.parse_loop_feiertage(termine)
                
	#holiday names are found at SUMMARY and is parsed here
    def parse_loop_feiertage(self, termine):
        results = []
        for start_ende in termine.readlines():
            
            if start_ende.startswith('SUMMARY:'):
                summary = start_ende[8:-1]

                if summary != 'Volkstrauertag':
                        summary = summary.replace('ue', 'ü')
                        summary = summary.replace('ae', 'ä')
                        summary = summary.replace('oe', 'ö')

                results.append(summary)

            #date of the holiday
            if start_ende.startswith('DTSTART;VALUE=DATE:'):
                datum_start = start_ende[19:27]
                ds = datum_start[6:8] 
                ms = datum_start[4:6] 
                ys = datum_start[0:4]
                #set day of the week with datetime.weekday()
                tag = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"][date(int(ys), int(ms), int(ds)).weekday()]

                datum = '{0}, {1}.{2}.{3}'.format(tag, ds, ms, ys)
                results.append(datum)
			
		#Send the final list to QMLs "onGetPythonList" function via BB-Tart
        tart.send("getPythonList", liste=results)
