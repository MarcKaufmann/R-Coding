# Coding 1: Data Management and Analysis with R

Coding 1: Data Management and Analysis with R

## Lecture 0: Technical Prerequisites *before* Class 1

Please bring your own laptop and make sure to install the below items **before** attending the first class. If you get stuck, read the "What to do if I can't complete a step?" section below first, before emailing me.

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

5. Bookmark, watch or star this repository so that you can easily find it later
6. Install `git` from https://git-scm.com/
7. Verify that in RStudio, you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
8. Create an RSA key (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub). Copy the public key and add that to you SSH keys on your GitHub profile.
9. Create a new project choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
10. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

    ```bash
    $ git config --global user.name "Your Name"
    $ git config --global user.email "Your e-mail address"
    ```
    Close this window, commit, push changes, all set.

Find more resources in Jenny Bryan's "[Happy Git and GitHub for the useR](http://happygitwithr.com/)" tutorial if in doubt or [contact me](#contact).

### What to do if I get stuck or can't solve something?

You should try the following strategies in this order.

#### 1. Use RStudio's built in help

If you don't know how to use a certain function, use R and RStudio's inbuilt help features. **[[[Expand]]]**

#### 2. Search the Internet

First search the internet to see if you can find the answer to your solution. Long after this class is over and when we -- Marc and Julia -- won't respond to help you, the Internet will be alive and well. Learning to solve your own issues will serve you for the long term, while asking us for help will not. Sites that are particularly likely to be helpful:

**[[[Add links and other resources.]]]**

- Stackoverflow
- RStudio website

#### 3. Discourse Forum

Second, use the class specific discourse forum (coming soon...) to post your questions. Make sure to respond to others' questions that you know how to solve.

##### How To Ask for Help

**[[[Link to stackoverflow or similar for minimal example and how to write them.]]]**
**[[[Provide an example.]]]**

#### 4. Message us on Discourse

If you are uncomfortable posting your question to the whole class, you can message us directly on the Discourse forum. 

I will however strongly discourage this as the term progresses *if* the reason that you don't want to post is that you simply feel it should be obvious or easy. Programming has lots of obscure corners, and I regularly spend anywhere between 5 minutes and 5 hours on installing or configuring various bits of software. Recently it took me 2 hours to realize that the error I received trying to switch from http to https (from unencrypted to encrypted internet traffic, essentially) was due to me having forgotten to switch off a firewall. In between, I had found 3 other possible 'solutions' that involved installing various tools, changing parts of the database, and so on. In the end, it was solved by running:

```bash
$ sudo ufw allow https
```

yet it had wasted 2 hours of my time. 

#### 5. Email us

I discourage emailing us for technical issues, which I prefer keeping on Discourse, so you should have a good reason to email us directly (such as that you can't log in to Discourse). Of course for non-technical questions or concerns, you are welcome to use email.
