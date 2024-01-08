# Introduction to Data Analysis in R

## Lecture 0: Technical Prerequisites *before* Class 1

Please bring your own laptop to class and make sure to follow the steps below to install software needed for the class. Do this **before** attending the first class, and do the steps in order. If you get stuck, read the "What to do if I can't complete a step?" section below first, before emailing me.

1. Install `R` from https://cran.r-project.org
2. Install `RStudio Desktop` (Open Source License) from https://www.rstudio.com/products/rstudio/download
3. Register an account at https://github.com
4. In this step you install the tidyverse packages, which includes `ggplot2`, the plotting library that we will use in this course. Enter the following commands in the R console (bottom left panel of RStudio) and make sure you see a plot in the bottom right panel and no errors in the R console:
5. Bookmark, watch, or star this repository if you want to find it easier later.

```r
install.packages('tidyverse')
library(ggplot2)
ggplot(diamonds, aes(cut)) + geom_bar()
```

## Optional: git

The remaining steps will allow you to install `git`. In the past, I required this. Experience tells me that I cannot teach git properly in this course, as it would require 1 or more lectures, which is not the point of the class. Thus, follow these steps only if you feel like it, otherwise you will have to download the scripts from the github repository manually. 

6. Install `git` from https://git-scm.com/
   - If you have no idea what git is and how and why to use it, this video does a decent job: [Git & GitHub Crash Course For Beginners](https://www.youtube.com/watch?v=SWYqp7iY_Tc)
8. If you want to use SSH to pull/push changes, create an SSH key, see the [instructions on GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
9. Fork the repository on GitHub: this will create a copy of my repository and put this copy in your account, making it easy to pull (meaning 'get') new changes as I write them, while allowing you to make changes to your copy as you follow along.

The next steps may be trickier to get right, so try to set it up for a while and ask for help -- if you get stuck for more than 15 minutes on any given step, give up and ask for help in class. We will go through in the first class as well, but you should attempt it.

9. Clone your fork of the repository on Github (that is in *your* account) to a folder on your computer, say to your /home/<your-name>/<path-to-course-materials>/R-Coding. For this, go to your fork of the repository and click on the green button saying 'Code' and copy the appropriate link:
        - if you did set up SSH keys, copy the SSH url (starting with `git@github.com`)
        - if you did not set up SSH keys, copy the HTTPS url (starting with `https`)
   - If *command line interface* means something to you, then open up a cli if you are on Linux or Mac, or launch the `git bash` application on Windows (it should have been installed with `git`)
   - Now navigate to the folder into which you want to clone *your fork of the repository* of this course. That is, if you want to have the repository in /home/<your-name>/courses/R-Coding, then change directory (with `cd` command) to /home/<your-name>/courses by typing the following (ignore the dollar-sign at the start, that is simply what that line is likely to look like):
   
   ```bash
   $ cd /home/<your-name>/courses
   ```
   - Next, clone the repository there by typing the following if you did set up SSH keys:
   ```bash
   $ git clone git@github.com:<your-username-on-github>/R-Coding.git
   ```
   and type the following if you did not set up SSH keys
   ```bash
   $ git clone https://github.com/<your-username-on-github>/R-Coding.git 
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

#### 3. Slack Channel

Second, use the class specific slack channel to post your questions. Make sure to respond to others' questions that you know how to solve.

#### 4. Message Instructor/TA on Slack

If you are uncomfortable posting your question to the whole class, you can message us directly on Slack.

I will however strongly discourage this as the term progresses *if* the reason that you don't want to post is that you simply feel it should be obvious or easy. Programming has lots of obscure corners, and I regularly spend anywhere between 5 minutes and 5 hours on installing or configuring various bits of software. 

One particularly fun episode (far from the most time-consuming) was when it took me 3 hours to realize that the error I received trying to switch from http to https (from unencrypted to encrypted internet traffic, essentially) was due to me having forgotten to switch off a firewall on my own server. In between, I had found 3 other possible 'solutions' that involved installing various tools, changing parts of the database, and so on. In the end, it was solved by running:

```bash
$ sudo ufw allow https
```

yet it had wasted 3 hours of my time. Close to one hour per word typed.

#### 5. Email 

I encourage Slack for technical issues, so that others can benefit as well. For non-technical questions or concerns that are unlikely to be of interest to other students, or if you have a question that is somewhat private, you are welcome to send us a private Slack message or email me (kaufmannm@ceu.edu).
