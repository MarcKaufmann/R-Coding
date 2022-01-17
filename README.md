# Introduction to Data Analysis in R

## Lecture 0: Technical Prerequisites *before* Class 1

Please bring your own laptop to class and make sure to follow the steps below to install software needed for the class. Do this **before** attending the first class, and do the steps in order. If you get stuck, read the "What to do if I can't complete a step?" section below first, before emailing me.

1. Install `R` from https://cran.r-project.org
2. Install `RStudio Desktop` (Open Source License) from https://www.rstudio.com/products/rstudio/download
3. Register an account at https://github.com
4. In this step you install the tidyverse packages, which includes `ggplot2`, the plotting library that we will use in this course. Enter the following commands in the R console (bottom left panel of RStudio) and make sure you see a plot in the bottom right panel and no errors in the R console:

```r
install.packages('tidyverse')
library(ggplot2)
ggplot(diamonds, aes(cut)) + geom_bar()
```

The remaining steps will allow you to install `git` and use it with RStudio:

5. Bookmark, watch, or star this repository so that you can easily find it later
6. Install `git` from https://git-scm.com/
8. If you want to use SSH to pull/push changes, create an SSH key, see the [instructions on GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

The next steps may be trickier to get right, so feel free to ask for help on Discourse. We will debug this in class, conditional on you having attempted it.

9. Clone the github repository for this class to a folder on your computer, say to your /home/<your-name>/<path-to-course-materials>/R-Coding. 
        - if you did set up SSH keys
        - if you did not set up SSH keys
   - If *command line interface* means something to you, then open up a cli if you are on Linux or Mac, or launch the `git bash` application on Windows (it should have been installed with `git`)
   - Now navigate to the folder into which you want to clone the repository for this course. That is, if you want to have the repository in /home/<your-name>/courses/R-Coding, then change directory (with `cd` command) to /home/<your-name>/courses by typing the following (ignore the dollar-sign at the start, that is simply what that line is likely to look like):
   
   ```bash
   $ cd /home/<your-name>/courses
   ```
   - Next, clone the repository there by typing the following if you did set up SSH keys:
   ```bash
   $ git clone git@github.com:MarcKaufmann/R-Coding.git
   ```
   and type the following if you did not set up SSH keys
   ```bash
   $ git clone https://github.com/MarcKaufmann/R-Coding.git 
   ```
   If it was successfull, it will have created a new folder named `R-Coding` that contains the course files.
   
### What to do if I get stuck or can't solve something?

You should try the following strategies in this order.

#### 1. Use RStudio's built in help

If you don't know how to use a certain function, use R and RStudio's inbuilt help features.

#### 2. Search the Internet

First search the internet to see if you can find the answer to your solution. Long after this class is over and when I won't be able to help you, the Internet will be alive and well (OK, maybe not well). Learning to solve your own issues will serve you for the long term, while asking me for help will not. Sites that are particularly likely to be helpful:

- Stackoverflow
- RStudio website

#### 3. Discourse Forum

Second, use the class specific discourse forum to post your questions. Make sure to respond to others' questions that you know how to solve.

##### How To Ask for Help

TO BE COMPLETED

#### 4. Message Instructor/TA on Discourse

If you are uncomfortable posting your question to the whole class, you can message us directly on the Discourse forum. 

I will however strongly discourage this as the term progresses *if* the reason that you don't want to post is that you simply feel it should be obvious or easy. Programming has lots of obscure corners, and I regularly spend anywhere between 5 minutes and 5 hours on installing or configuring various bits of software. 

One particularly fun episode (far from the most time-consuming) was when it took me 3 hours to realize that the error I received trying to switch from http to https (from unencrypted to encrypted internet traffic, essentially) was due to me having forgotten to switch off a firewall on my own server. In between, I had found 3 other possible 'solutions' that involved installing various tools, changing parts of the database, and so on. In the end, it was solved by running:

```bash
$ sudo ufw allow https
```

yet it had wasted 3 hours of my time. Close to one hour per word I had to type.

#### 5. Email 

I discourage emails for technical issues, which should be kept on Discourse for the benefit of users. For non-technical questions or concerns that are unlikely to be of interest to other students, or if you have a question that is somewhat private, you are welcome to write emails.
