# The name of the dataset is (as shown here): tasmania_test_1.txt
# Be sure to modify the file location to the location where
# you saved your tasmania_test_1.txt file.

tasmania <- read.table('tasmania_test_1.txt', header=T)

##### First, a binomial model will be fit to
#####    the data using the glm function
# The assumption here is a constant probability, such that
# counti ~ independent      Binomial(group_sizei, p), 1 = i = N
# Reference, Altham 2002

attach(tasmania) # This way, column headings may be
                 #   called out for analysis
names(tasmania) # What are those column headings?

#### Examine for potential overdispersion
####    using non-statistical methods

table(tasmania[,3]) #### notice how there are more
                    ####    quadrats with 6 disease plants