#set align(center)
#set text(
  font: "Times New Roman",
  size: 32pt
)

CMP3749 BIG DATA ASSIGNMENT

#set text(
  font: "Times New Roman",
  size: 24pt
)

Word Count: Task 1: 923, Task 2: 903, Task 3: 652 

Vishal Maisuria - 26439978

26439978\@students.lincoln.ac.uk

#pagebreak()
#set text(size: 14pt)
#set align(left)
#counter(page).update(1)
#set page(numbering: "1")
#outline()
#set heading(numbering: "1.1.")

#pagebreak()

= Task 1 - Pyspark Implementation of Recommendation System 923
The objective of task 1 was to develop a recommendation system, where I chose to implement collaborative filtering. This involved analysing movie rating data to predict user preferences. The core tool used for this task was Pyspark, a powerful library that handles large-scale data efficiently. 

== Design and Data Preparation 
The first step was to load the data from the CSV file into a Spark DataFrame, ensuring they adhered to a schema that I predefined for consistency and ease of manipulation. After loading the data, I performed data cleaning operations to remove any null values, to ensure data quality and duplicates, to maintain data integrity and avoid skewing the model. To do this, I used PySpark's "dropna()" and "dropDuplicates()" functions. This resulted in an efficient preparation of datasets, considering that they were fairly large. Ratings had 1 duplicate, and Trust had none. Neither dataframe contained any null values. Doing this ensured the integrity of the data, and as a result crucial for the success of the model, as data of a poor quality can lead to distorted results.

#figure(
  image("Screenshot 2024-12-28 at 12.24.50.jpeg", width: 60%),
  caption: "Data Preparation"
)<fig:DataPreparation>

== Data Analysis
To further understand the trust dataset I was working with, I conducted analysis of the data. This involved calculating the count, mean, standard deviation, as well as the quartiles. 

- Most ratings are clustered between 3.0 and 4.0, with 4.0 having the most frequency (@fig:VisualisationRatingsData). This shows that users prefer rating movies highly.

- The top 10 users, contributed many ratings of movies. Users 272 and 1187 contributed the most ratings (@fig:Top10UsersMostRatings). This could be due to their high activity, and could be noted for further marketing purporses.

- The top 10 movies are movies that received the most ratings, with movie 7 receiving the most ratings (@fig:Top10MoviesMostRatings). Other movies such as 2 and 11 also recevied many ratings, but this does not determine whether they are positive or negative ratings. This could be used to determine the most liked or most disliked movies, and could be used for marketing purposes.

In the trust dataset, there was a mean Trustor of 775.4 and a mean Trustee of 782.2, with a standard deviation of approximately 447.7 for Trustor and 471.6 for Trustee. This shows that the trust values are spread out, and signifies a wide range of users involved. All trust values were uniformly 1.0, (@fig:TrustValDistribution) which indicates a binary trust with no variability. 

#figure(
  image("Screenshot 2025-01-02 at 15.06.30.jpeg", width: 60%),
  caption: "Ratings Data Analysis"
)<fig:RatingsDataAnalysis>


== Training and Testing

The data was split into training and testing sets using an 80/20 split ratio, which ensured that the model was trained on a majority of the data and tested on a smaller subset to evaluate its performance. To do this, I utilised the "randomSplit" function in PySpark. 

#figure(
  image("Screenshot 2025-01-01 at 16.55.12.jpeg", width: 80%),
  caption: "Data Splitting"
)

The reason for the split ratio is derived from the Pareto principle, which states that for a wide variety of situations, about 80% of the outcome is caused by around 20% of causes @david_pareto_2022. This split balances the need for a robust training set, and a meaningful evaluation dataset to assess performance.

I decided to implement collaborative filtering, which builds a model from a user's past behaviours as well as similar decisions made by other users @liao_prototyping_2018. To implement collaborative filtering, I used the Alternating Least Squares (ALS) algorithm. This algorithm is beneficial due to its scalability and ability to handle large datasets efficiently.

Compared to content-based filtering, collaborative filtering is better for recommending items that are popular among similar users, introducing them to new movies. This is preferred in a situation like a movie recommender as content-based filtering would only recommend movies similar to the ones the user has already watched, which could limit the user's exposure to new movies @glauber_collaborative_2019. On the other hand, content-based filtering offers a robustness in sparse data, as it does not rely on user-user similarity, compared to collaborative filtering, which has problems in performance when data is sparse. 

To get the best of both worlds, it may be beneficial to implement a hybrid recommendation system, which combines collaborative and content-based filtering to provide a recommendation system with novelty, as well as robustness when encountering sparse datasets.


== Implementation of Recommendation System 
The ALS model was configured with the following hyperparameters: 

- _MaxIter_: I also set this 10, which is the iterations to balance training time and performance.
- _RegParam_: I set this to 0.1, which is the regularisation parameter to prevent overfitting.
- _Rank_: I set to 10, which detemines the number of latent factors in the model.
- _Cold Start Strategy_: I set this to 'drop', which results in missing predictions being handled gracefully. 

To train the model, I used the "fit()" function, which trained the model on the training set. Refining the hyperparameters was crucial, as each parameter was chosen to ensure optimal performance. 

#figure(
  image("Screenshot 2025-01-01 at 17.11.16.jpeg", width: 60%),
  caption: "ALS Model Initialisation"
)

Once trained, the ALS model predicted ratings for the test set. I used evaluation metrics such as Root Mean Squared Error (RMSE), which is useful when the goal is to minimise overall error, and Mean Absolute Error (MAE), which is useful when the goal is to minimise overall error, while avoiding large errors @induraj_which_2023. 

The evaluation was conducted using PySpark's "RegressionEvaluator", which efficiently calculated the RMSE and MAE values. I got a RMSE value of around 0.87 and a MAE value of around 0.67, which indicates a reasonable level of prediction accuracy. Overall, PySpark's ability to efficiently handle large-scale data and its built in machine learning capabilities were vital in developing a robust recommendation system.

#figure(
  image("Screenshot 2024-12-28 at 12.34.49.jpeg", width: 60%),
  caption: "Recommendation System Evaluation"
)<fig:RecommendationSystemEvaluation>

The trained model was used to generate recommendations:
- _User recommendations_: recommending five films for each user.
- _Film recommendations_: recommending five users for each film.

To do this, I utilised Pyspark's "recommendForAllUsers()" and "recommendForAllItems()" functions. These recommendations were based on the predicted ratings generated by the ALS model. 

#figure(
  image("Screenshot 2025-01-01 at 20.45.14.jpeg", width: 60%),
  caption: "Film recommendations for each user"
)

#figure(
  image("Screenshot 2025-01-01 at 20.45.22.jpeg", width: 60%),
  caption: "User recommendations for each film"
)
= Task 2 - MapReduce for Margie Travel Dataset 903
The second task revolved around utilising the MapReduce model to analyse the Margie Travel dataset. There were two files containing lists of data. The first file contained details of passengers that have flown between airports over a certain period, and the second file provided a list of airport data, such as the name, IATA/FAA code, and location. The goal was to use MapReduce, because of its simplicity, scalability and fault-tolerance @maitrey_mapreduce_2015.

== Design and Data Preparation

The design and preparation stage was crucial to ensure the data was structured correctly and ready for analysis. By doing this, the results from the MapReduce operations were reliable and precise. The first step was to load the datasets into Pandas DataFrames, as this allowed for efficient data manipulation and consistency. Here, for clarity, I renamed the columns which made the dataset easier to interpret and allowed for clarity when writing my mapper and reducer functions. Renaming my columns also minimised coding errors. To convert the time into HH:MM format, I designed a helper function to convert the epoch timestamps from the dataset into human-readable format. This resulted in a better interpretation of flight schedules.


== Implementation of MapReduce
I implemented the MapReduce framework to address three goals: counting flights, converting epoch times to HH:MM, and calculatng the highest air miles travelled by passengers. To accomplish this, I utilised mapper and reducer functions to process the dataset to achieve the goals efficiently. 

=== Counting Flights
The first MapReduce operation focused on counting the number of flights from each airport. To do this, I used a two-phase process with mapping and reducing.

The mapper function, iterated through the dataset, creating key-value pairs where keys were airport codes, and values were flight counts. 

The reducer aggregated these counts, providing the total number of flights from each airport. This process was useful for identifying the busiest airports in the dataset, as well as those airports that were unused. This provided valuable data that can be used for resource optimisation and operational planning.


From a business perspective, identifying high and low-traffic airports can inform decisions about staffing, infrastructure investment and how particular services can be enhanced. Similarly, airports that are not utilised as much might present opportunities for new routes or partnerships that would make operations much more efficient.

#figure(
  image("Screenshot 2024-12-28 at 16.56.05.jpeg", width: 60%),
  caption: "Mapper and Reducer for Counting Flights"
)<fig:MapperReducerCountingFlights>

#figure(
  image("Screenshot 2024-12-28 at 17.29.48.jpeg", width: 100%),
  caption: "Number of Flights from Each Airport and Unused Airports"
)

=== Converting Epoch time to HH:MM
It was ideal to convert the epoch time that was in the dataset into typical HH:MM format, which is human-readable. To do this, I created a helper function, which took in a single argument "epoch", which is the time in seconds since January 1, 1970. "datetime.utcfromtimestamp()" is a method from Python's "datetime" module, that converts the epoch timestamp into a UTC object, which is much more understandable to humans. After some formatting, and error handling, the time is now readable and better to interpret (@fig:flightdetails). 

The ability to interpret flight schedules in a clear and accessible manner using HH:MM formart benefits multiple stakeholders. Airlines can use this to easily optimise schedules, passengers can plan travel effectively, and analysts can easily gain insights into behaviours of airlines and passengers. For example, identifying peak hours where many travellers fly can help with resource allocation to suit high-demand periods.

#figure(
  image("Screenshot 2025-01-05 at 12.59.14.jpeg", width: 100%),
  caption: "Helper function to Convert Epoch Time to HH:MM"
)

After this, it was required to collect flight details, such as departure and arrival airports, flight times and passenger counts. I created another mapper function, which extracted and formatted this information, while the reducer aggregated the data. This operation was useful for identifying the most popular flight routes, as well as the busiest times for travel. This information that had been extracted could then be used for further analysis or improvement. 

#figure(
  image("Screenshot 2024-12-28 at 17.34.40.jpeg", width: 100%),
  caption: "Flight Details"
)<fig:flightdetails>

=== Highest Air Miles

The final task was to calculate the total air miles travelled by each passenger. 

Initially, I needed to calculate the distance between each airport for each passenger. To accomplish this, I again used a mapper and reducer function, where the mapper calculates the distance traveled by each passenger for each flight, and the reducer totals the distances travelled that results in a total global distance. 

#figure(
  image("Screenshot 2025-01-03 at 15.29.09.jpeg", width: 70%),
  caption: "Mapper and Reducer Functions for Miles Travelled"
)


The aim of the task was to display the total miles calculated. To do this, I utilised Pandas' ability to create a dataframe using only the "Passenger ID" and "Total Miles" columns. After this, I select 10 rows with the highest "miles" values. "top_10_passengers" is a subset of the dataframe that only contains the top 10 passengers.

#figure(
  image("Screenshot 2025-01-02 at 17.43.47.jpeg", width: 100%),
  caption: "Implementation of Passenger with Highest Air Miles"
)


#figure(
  image("Screenshot 2024-12-28 at 17.43.19.jpeg", width: 100%),
  caption: "Passenger Air Miles"
)

Visualisation was key in this task, as it would be very beneficial for a wide range of scenarios to have the data presented in a way that is easy to understand by people of all abilities, and also easy to interpret for many reasons, whether that be business related or otherwise. This is why I created a bar chart displaying the appropriate information, @fig:numflightsAirport to visualise the number of flights from each airport, and @fig:visualisationpassengerairmiles to visualise the highest air miles by passengers. Visualising this data demonstrates the potential for business optimisation, whether that be through marketing campaigns or the potential for loyalty programs. For example, passengers with exceptionally high miles could be offered incentives such as discounts or lounge access, demonstrating business appreciation and customer retention.

These operations demonstrates the power of MapReduce in decomposing problems into manageable tasks, which can be executed efficiently. Not only did these operations demonstrate the framework's ability, but also gathered valuable insights into the dataset:

- The task of counting flights provided a clear picture of airport activity, and identified potential areas for improvement.
- Calculating the miles travelled by passengers offered insights into their behaviour, allowing for targeted marketing strategies and loyalty programs.

= Task 3 - Big Data Tools and Technology Appraisal 652
The methodologies used in tasks 1 and 2 reflect my understanding of big data concepts and techniques. This appraisal evaluates their effectiveness and scalability while providing recommendations for future improvements.

== Analysis of PySpark in Task 1
Pyspark was instrumental in developing the recommendation system because of its ability to handle large datasets efficiently and faster than other options, for example sci-kit learn @junaid_performance_2022. I used the Alternating Least Squares (ALS) algorithm, which is well-suited for collaborative filtering tasks, and is highly scalable with the ability to handle large datasets effectively. The algorithm was straightforward to implement, and ALS minimises the error by adjusting the latent factors in the model, resulting in accurate predictions @mishra_movie_2024. Unlike KNN-based approaches, ALS efficiently factorises the interaction matrix into latent features @liao_prototyping_2018-1. This scalability makes it a practical choice.  The use of PySpark's DataFrame API streamlined the data manipulation process, which resulted in an efficient implementation considering my lack of experience with the tool.

However, the ALS algorithm had some limitations, one of which was the cold-start problem, which was the difficulty to recommend items to new users or items with no ratings, as there is nothing to go from. This limits the applications that this algorithm could be used for. A mitigation for this could be to use a hybrid recommendation system, which combines collaborative filtering with content-based filtering, to provide recommendations for new users or items @liao_prototyping_2018. 

== Analysis of MapReduce in Task 2
MapReduce is a useful programming model framework for large scale data processing @hashem_mapreduce_2016. I used this tool in task 2 to process and aggregate flight data, and return the requested values. The tasks were to calculate the number of flights from each airport, airports that are unused in the dataset, and the details of flights. The simplicity of the programming model resulted in a straighforward implementation of the tasks. MapReduce's fault-tolerance ensured reliable execution of the tasks, even in the presence of failures. This resulted in a robust product, ideal for critical operations.

However, MapReduce had some limitations, for example the reliance on real-time data processing, which could be a bottleneck for some applications. Using modern abstractions like PySpark could mitigate these problems, allowing for better scalability and fault-tolerance. Another challenge was the lack of support for advanced analytical functions. This could be resolved by implementing tools like PySpark, which would provide better scalability.

== Visualisation and Interpretation
Visualisation was key in both of the tasks, as it allowed me to display the results of the analysis in a clear and understandable way, which is important for many reasons. Good data visualisation can share summary analysis in a simple manner, along with better business insights @rahman_python_2021. By enabling quick visual displays, it helps identify trends and anomalies, for example it was quick identify that the higher rating values of films had a higher frequency (@fig:VisualisationRatingsData).

To visualise the data, I used the _pandas_, _matplotlib_ and _seaborn_ libraries. These libraries allowed me to create bar charts and line graphs, which provided valuable insights into the dataset's characteristics. 

#figure(
  image("Screenshot 2025-01-02 at 15.23.09.jpeg", width: 90%),
  caption: "Top 10 Users with Most Ratings"
)<fig:Top10UsersMostRatings>

#figure(
  image("Screenshot 2025-01-02 at 15.33.00.jpeg", width: 90%),
  caption: "Top 10 Movies with Most Ratings"
)<fig:Top10MoviesMostRatings>

#figure(
  image("Screenshot 2025-01-02 at 15.54.04.jpeg", width: 90%),
  caption: "Trust Value Distribution"
)<fig:TrustValDistribution>

#figure(
  image("Screenshot 2024-12-29 at 20.56.48.jpeg", width: 100%),
  caption: "Visualisation of Ratings Data"
)<fig:VisualisationRatingsData>

#figure(
  image("Screenshot 2025-01-03 at 12.15.00.jpeg", width: 90%),
  caption: "Number of Flights from Each Airport"
)<fig:numflightsAirport>

#figure(
  image("Screenshot 2024-12-29 at 20.57.11.jpeg", width: 100%),
  caption: "Visualisation of Passenger Air Miles"
)<fig:visualisationpassengerairmiles>

== Future improvements
After evaluation of my current implementation and the tools that I used, I have identified some ways that this could be improved. Improving the recommendation system would result in a more efficient and accurate model that would be able to work on a wider range of data, along with not struggling with cold-start problems.

To further enhance scalability, I could improve my current implementation by using cloud-based services like AWS. Cloud-based platforms offer distributed storage and computing resources, enabling efficient handling of datasets. This would allow me to process and access data remotely, which would be beneficial in terms of resource management and cost-effectiveness. Also, this would futureproof programs, as the datasets increase in size.

To conclude, both Pyspark and MapReduce have strengths and weaknesses for different situations. PySpark excels in iterative tasks, while MapReduce is better suited for batch processing. After understanding these strenths and weaknesses, I can embrace hybrid implementations, getting the best of both worlds and achieving a more efficient and effective solution.




#pagebreak()
#bibliography("references.bib", style: "university-of-lincoln-harvard.csl", title: [References], full: true)

