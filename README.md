# Interview Questions

This is a place to put interview questions I have been asked.
Coding on a white board or a piece of paper is completely unnatural.
The solutions in this repository are how I actually code.

Assessing a programmer with a paper or whiteboard exercise is like
assessing a person's table manners after giving them a straw to
use to eat a meal.  The exercise is not entirely without merit but
it is insane and silly.

# Installation Instructions

Running these programs requires the [Elixir][elixir-home]
programming language.
Instructions for installing Elixir can be found [here][elixir-install].

Clone this repository.

{% highlight sh %}
git clone git@github.com:sgeos/InterviewQuestions.git
mv InterviewQuestions interview_questions
cd interview_questions
{% endhighlight %}

If **env** is located at **/usr/bin/env**, then the programs can be executed.

{% highlight sh %}
chmod +x *.exs
./fizz_buzz.exs -s 2 -F Big... -B Scary... -W Monsters!
{% endhighlight %}

Otherwise **elixir** can be used to run them.

{% highlight sh %}
elixir fizz_buzz.exs -s 2 -F Big... -B Scary... -W Monsters!
{% endhighlight %}

# Software Versions

{% highlight sh %}
 date -u "+%Y-%m-%d %H:%M:%S +0000"
2016-11-02 02:15:04 +0000
$ uname -vm
FreeBSD 12.0-CURRENT #0 r307959: Thu Oct 27 01:15:33 JST 2016     root@mirage.sennue.com:/usr/obj/usr/src/sys/MIRAGE_KERNEL  amd64
$ mix hex.info
Hex:    0.13.0
Elixir: 1.3.4
OTP:    19.1.5
{% endhighlight %}

# Links

[Elixir, Home Page][elixir-home]
[Elixir, Installing Elixir][elixir-install]

[elixir-home]: http://elixir-lang.org
[elixir-install]: http://elixir-lang.org/install.html

