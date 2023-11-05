# pipeline-secondarymarket

This repository includes some of the analysis and data that I am currently working on as a research assistant for Professor Yanyou Chen as of 2023. The project aims to look at natural gas pipeline and shipper's participation in the secondary market. Data from both the primary market and secondary market are utilized in this analysis. 

This repository is organized as follows:

Data is split into clean and raw. Clean provides examples of the merged files combining all companies per quarter(quartermerged_AL), created through the data cleaning scripts. The main datasets used to generate output, the compiled Index of Customers (IOC) data from appending each cleaned merge file, and secondary market data (Capacity Release) after standardizing company names across datasets, are too large for GitHub and hence not uploaded. They are accessible through the link https://utoronto-my.sharepoint.com/:f:/g/personal/annadl_li_mail_utoronto_ca/Eid7fjIvDSZAo2kK9gsY714BCpxsIjVZY5qKJ_pM8bc2CA?e=hrckRI. 
These are the primary files that are used to generate output. Raw data provides sample data that was pulled and cleaned from the Federal Energy Regulatory Commission Form 549B Index of Customers https://www.ferc.gov/industries-data/natural-gas/industry-forms/form-549b-index-customers.  

Scripts includes 3 main scripts used for generating outputs, along with additional scripts used for rudimentary analysis and for cleaning the raw data. The Investigation files generate some of the descriptive statistics presented in the final output. Ranking Shippers and Market Concentration are used to rank participants in the market based on number of contracts and quantity owned per pipeline to identify trends and dominant players. All analysis is done in Stata, utilizing .do files. 

Output includes descriptive statistics of the pipelines and shippers within the two markets, using the finalized datasets, within the pdf Pipeline_SecondaryMarket. The results of market concentration calculations based on different definitions can be found within the excel file. Finally, some of the iterations of previous results done for preliminary analysis can be found within the subfolder of Rough Results. 

