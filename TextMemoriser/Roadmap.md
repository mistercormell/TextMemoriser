# Roadmap

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

Tasks:
1. Add Dictation to Learn a verse view - DONE
2. Tweak Guess the Location view to have 3 modes - DONE
3. Make Lesson mode to take them through all the questions in order (without unfinished modes) - DONE
4. Build the verse mode added and included in lesson mode - DONE
5. Fill in the blank mode with dictation added and included in lesson mode
6. Strength metric captured and displayed simply as colour on learning set view
7. Practice mode revamped to use new question types and strength metric
8. Custom timed notifications
*** REFACTOR AND CODE IMPROVEMENTS ***
9. Fancy UI enhancements to question types (e.g. strengths progress bar)

###Learning / Practice Mode

Thinking / requirements:

I want to take a single verse or set of related verses and memorise it/them
I want to ensure that previously memorised verses continue to stick.

Single Verse Lesson Objective:-

Take the user through a series of exercises / tasks to help them commit that verse (words and location) to memory.
Depending on how many they got right and what type of mistakes they made determines the strength of that verse.
For any given verse there are stages of learning:
- I can tell you what book in the bible it comes from
- I can tell you the book and chapter it comes from
- I can tell you the book, chapter and verse it comes from
- Given a verse's location: I can tell you the verse 

Types of activity:
- Select the location (book, book+chapter, book+chapter+verse)
- Fill in the blank (varying number of blanks) - dictated response
- Re-arrange the verse (verse chunked up into varying size blocks)
- Build the verse (only 4/5 options for the next word in the verse are shown until the whole verse is built)


- Select the location is easy enough to implement in all three difficulties
- Re-arrange the verse (already built)
- Build the verse (modification of existing Re-arrange the verse view) - should be straightforward
- Verse is dictated (using AVFoundation's AVSpeechSynthesizer')
- Verse is transcribed and checked - SFSpeechRecognizer and AVAudioSession

Typical Lesson:-

1. Show verse and location
2. Verse is dictated including reference
3. Select the location (book)
4. Fill in the Blank (10% blanked) - dictated
5. Re-arrange the verse (4 blocks)
6. Select the location (book + chapter)
7. Fill in the Blank (25% blanked) - dictated
8. Re-arrange the verse (8 blocks)
9. Select the location (book + chapter + verse)
10. Build the verse
11. Fill in the Blank (50% blanked) - dictated
12. Re-arrange the verse (words)
13. Select the location (book + chapter + verse)
14. Fill in the Blank (100% blanked) - dictated

As lesson progresses, strength bar increases based on metric (which must be between 0 and 1). After a correct answer, play a ding and animate this bar, bar doens't move for incorrect answer and can't repeat questions. It should reveal the correct answer.

Strength Metric:- (MVP, but to be improved later)

For each verse in learning set:

- Last date/time a question was asked about this verse
- Number of times question asked on this verse
- Number of times a question was answered correctly
- Can calculate it's strength from this: e.g. number of questions asked + question answered correctly * 3 - number of days since last revised * weighting

Practice Mode:-

- Can ask about any verse in learning set
- Can start and stop freely (open-ended)
- Pick next verse to ask based on:
---- Oldest (in future adjust to consider prioritising by also looking at strength e.g. once they are tied, focus on strength)
- Based on strength length ask a suitable question for that verse (based on lesson pathway)
- Adjust strength metric

