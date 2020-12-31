# Witchcraft DB Notes

## TO DO
- Maps
  - Map with info on each individual
  - Choropleth --> use R to calculate density of each area

- Healing practices
  - WDB_Case
    - SpecificVerbalFormulae
    - SpecificRitualActs

- Analysis of Ritual Objects and their relation to fairies

- Compare male:female ratio of entire database vs fairy database

- Text analysis on descriptions of devil
  - WDB_DevilAppearance
  - WDB_Confession
  - RELATE TO POEM ABOUT KING/QUEEN OF ELPHANE

- Text analysis on notes
    ```
    SELECT "WDB_Accused"."Notes",
    "WDB_Case"."Charnotes",
    "WDB_Case"."DevilNotes",
    "WDB_Case"."MeetingNotes",
    "WDB_Case"."FolkNotes",
    "WDB_Case"."DiseaseNotes",
    "WDB_Case"."OtherMaleficialNotes"
    "WDB_Case"."OtherChargessNotes",
    "WDB_Case"."DefenseNotes",
    "WDB_Case"."CaseNotes",
    "WDB_Case_person"."Notes",
    "WDB_Commission"."Notes",
    "WDB_Confession"."Notes",
    "WDB_MentionedAsWitch"."Notes",
    "WDB_OtherNamedwitch"."Notes",
    "WDB_Person"."Notes",
    "WDB_Ref_Parish"."Notes",
    "WDB_Notes"."Notes",
    "WDB_Trial"."PretrialNotes",
    "WDB_Trial"."TrialNotes",
    "WDB_Trial"."PostTrialNotes"
    FROM "WDB_Accused";
    ```

## Technical
- Disappointing that the primary sources themselves were not digitized --> have to rely on the notes made by those who created the database
  - What affect might this have on results of analysis of this text?
- Database has odd relational structure --> changing column names make it difficult to track
- Hm RMDBs need to be hosted on server to work w website --> concerned about legality of hosting the whole database on a publicly accessed server...
- Really only need individual's data for mapping --> export needed data to CSV file?
  - Let's find out how many people we're mapping first
    - Every map point should have
      - Accused individual's name
      - Case_date --> establishes year that witchcraft was "acted upon", could indicate time period where witchcraft overtakes faeries in explaining of unusual events/occurences
      - Gender --> who was more likely to be accused? what does this say about the characterization of faaries and in turn, what does this say about the characterization of witches and/or the devil?
      - Age (if possible) --> similar to above, with additonal question of what could this say about accused's implied motives for engaging in witchcraft? (faeries associated with beauty and youthfulness)
      - Small case summary (if available)
      - Link to full profile in actual database --> will have to add manually
        - http://witches.shca.ed.ac.uk/index.cfm?fuseaction=home.caserecord&caseref=C/EGD/1957&search_string=date%3D%26enddate%3D%26char%3Dany%26char%5Fop%3DAND%26ritual%5Fobject%3Dany%26rit%5Fop%3DAND%26calendar%5Fcustom%3Dany%26cal%5Fop%3DAND%26non%5Fnatural%5Fbeing%3Dany%26nnb%5Fop%3DAND%26demonic%5Fpact%3Dany%26pact%5Fop%3DAND
        - Will just have to replace CaseRef for each link nice
  - Now what do we need to check to find fairy related cases?
    - WDB_Case columns --> start point
      - Fairies_p
        - Fairies_s
      - Folk_healing_p --> those who practice folk healing are often thought to/have claimed that they were taught this by the "good neighbours"
        - Folk_healing_s
      - Elphane/Fairyland
        - Food/Drink
      - Shape-Changing --> fairies notorious shape-shifters
        - Sympathetic magic
      - FolkNotes IF mention of green, tree, fairy, good neighbours, water, spirits (ref case C/EGD/1278), stone(s)
      - RecHealer
    - Other tables
      - WDB_MusicalInstrument
        - IF MusicalInstrument_Type is pipe or whistle
      - WDB_WitchesMeetingPlace
        - IF loction is Moor or Fairy Hill/mound
      - WDB_ReligiousMotif
        - Where Motif_Type is holy well
      - WDB_RitualObject
        - Where RitualObject_Type is elfshot/nature/metal
          - Rok/distaff perhaps
    - Crafting SQL query
      - Oh wow this is going to be terrifying --> database structure does not lend itself to simple queries because of how divided it is
        - What does this say about the thoughts of those who created it? Why did they choose to divide it like this?
      - Going to have to include "CaseCommonName" from WDB_Case alongside full name from WDB_Accused to account for unnamed witches
      - Will have to tag lat/long coordinates to end of CSV manually...
      - This would take SO much less time if the creators of this database used consistent naming practices
      - Final query:
        - ```
          SELECT "WDB_Case"."CaseRef",
          "WDB_Case"."CaseCommonName",
          "WDB_Accused"."FirstName",
          "WDB_Accused"."LastName",
          "WDB_Case"."Case_date",
          "WDB_Accused"."Res_settlement",
          "WDB_Accused"."Res_county",
          "WDB_Accused"."Res_burgh",
          "WDB_Accused"."Sex",
          "WDB_Accused"."Age",
          "WDB_Accused"."Occupation",
          "WDB_Case"."CaseNotes",
          "WDB_Case"."FolkNotes"
          FROM "WDB_Case"
          INNER JOIN "WDB_Accused" ON "WDB_Case"."AccusedRef"="WDB_Accused"."AccusedRef"
          WHERE "WDB_Case"."Fairies_p" OR
          "WDB_Case"."Fairies_s" OR
          "WDB_Case"."Folk_healing_p" OR
          "WDB_Case"."Folk_healing_s" OR
          "WDB_Case"."Elphane/Fairyland" OR
          "WDB_Case"."Food/Drink" OR
          "WDB_Case"."Shape-Changing" OR
          "WDB_Case"."SympatheticMagic" OR
          "WDB_Case"."RecHealer" OR
          "WDB_Case"."FolkNotes" LIKE '%green%' OR
          "WDB_Case"."FolkNotes" LIKE '%tree%' OR
          "WDB_Case"."FolkNotes" LIKE '%fairy%' OR
          "WDB_Case"."FolkNotes" LIKE '%plant%' OR
          "WDB_Case"."FolkNotes" LIKE '%good neighbour%' OR
          "WDB_Case"."FolkNotes" LIKE '%water%' OR
          "WDB_Case"."FolkNotes" LIKE '%spirit%' OR
          "WDB_Case"."FolkNotes" LIKE '%stone%' OR
          "WDB_Case"."FolkNotes" LIKE '%elfshot%' OR
          "WDB_Case"."FolkNotes" LIKE '%herb%';
          ```
        - An absolute beast of a query
  - SAFE: should not experience too much lag --> 311 rows/cases that include some relation to fairies
    - 311/3413 = approx. 9.1% of cases
    - Can remove the CaseCommonName column --> no related cases without named individuals
      - No cases with information AVAILABLE anyway
- Mapping
  - Some locations specific, some unspecific --> start from settlement, and if that info is not available I can move on to county/burgh
    - Will use the locations found in [other mapping project](https://w.wiki/6rX) when I can
  - Database listed many places of residence as "unknown" yet when checking the SSW site I can find the location through clicking around --> such a strange structure...
  - Oh thank goodness all my points successfully plot
    - Okay there's one point suspiciously in Russia but it's still there so win!
  - Sorting witches by gender --> interested in the ratio for these cases
    - An age filter might be interesting as well
- Annoying that that the database states that there's confession text/details available but doesn't link to *where* it is available
  - Able to find some of the records digitized but not the ones needed
- Visualisations
  - Gathering data
    - The database is structured in a way that I can't query multiple tables without duplicates being returned...
      - Separate queries for all the notes then merge into csv
  - FolkNotes Topic Model
    - Going to sort data by years rather than specific dates --> looking for overall trend rather than details
  - Devil Text analysis
    - So many words that I can't think of a good way to visualize...
    - Circle packing most promising --> interactivity makes smaller counts more readable
    - For notes analysis I'm omitting words with a count lass than 5 --> too much data to visualize
      - Include link to raw data?

## Observatory
- Beetles thought to be coach/horse of the devil
- Some items used by accused witches are items that historically protect against fairies --> like many accused women who counter their accusation by stating they're religious, could Scottish women have used these fairy wards in the same manner?
- When looking for woodcuts to use as map markers, I got many depictions of witches instead of fairies
- Straw dolls used by witches comapred to straw dols that become changlings used by fairies
- With the exception of the midlands (Glasgow/Edinburgh area), these cases seem to be mostly coastal
  - More unpredictable/violent weather once attributed to fairies now attributed to witchcraft?
- Devil exists in the same plane/realm as fairies --> where does the Devil fit in then?
  - "She linked the elves and the Devil by saying that the Devil gave elves instructions on how to use and make elfshot and that they fire the shot in the Devil's name" -Issobell Gowdie
- For a very rural area, the Shetland/Orkney islands have a surprisingly large number of cases with fairy connotations --> influence of mixed Scottish/Scandinavian culture?

## Conclusions
- In the future, I would be interested in looking at whether or not there's a link between methods used to torture the accused and methods used to ward off malicious fae
- This database is meant to be open to be used by others for their own research, yet the documentation provided focuses more on the historiography than information

## Sources
- The Witch: A History of Fear, from Ancient Times to the Present: https://books.google.ca/books?id=M6llAQAACAAJ&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false
- Getting Shot of Elves: Healing, Witchcraft and Fairies in the Scottish Witchcraft Trials: https://www-jstor-org.proxy.library.carleton.ca/stable/30035236?seq=1#metadata_info_tab_contents
- Archaeology and Folklore: https://books.google.ca/books?hl=en&lr=&id=s3h3JER7RmgC&oi=fnd&pg=PR16&dq=Archaeology+and+folklore,&ots=uWVRoDsHGn&sig=kcSaJ0JftA4XlqzcXMoIG4hW0LI#v=onepage&q=Archaeology%20and%20folklore%2C&f=false
- Icon: https://search.wellcomelibrary.org/iii/encore/record/C__Rb1603070?lang=eng
- ‘Elderly years cause a Total dispaire of Conception’: Old Age, Sex and Infertility in Early Modern England: https://academic.oup.com/shm/article/29/2/333/2240730?login=true
- Scotland LAD data: https://github.com/martinjc/UK-GeoJSON
- Counting Witches: https://www.euppublishing.com/doi/abs/10.3366/jshs.2017.0200?journalCode=jshs
