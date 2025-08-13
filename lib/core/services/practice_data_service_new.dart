import '../../data/models/practice.dart';
import '../../data/models/travel_mode.dart';

class PracticeDataService {
  static List<Practice> getPractices() {
    return [
      // Mindful Breath Practice
      Practice(
        id: 'mindful_breath',
        title: 'Mindful Breath',
        description: 'A gentle breathing practice to center yourself during travel',
        availableDurations: [2, 5, 10],
        compatibleModes: [TravelMode.car, TravelMode.train, TravelMode.flight, TravelMode.general],
        audioUrl: 'assets/audio/386_Music/chill-lo-fi-beat-with-faint-wind-sounds-369302.mp3',
        practiceTextByDuration: {
          2: '''Take a comfortable seated position. Close your eyes gently or soften your gaze.

Begin by taking three deep breaths:
Inhale slowly through your nose for 4 counts
Hold for 2 counts
Exhale slowly through your mouth for 6 counts

Now settle into your natural breathing rhythm. Simply notice each breath as it comes and goes.

If your mind wanders, gently bring your attention back to your breath.

Continue this practice for the next minute, finding calm in the rhythm of your breathing.''',
          5: '''Find a comfortable position and close your eyes gently.

Begin with three cleansing breaths:
Inhale deeply through your nose, filling your lungs completely
Hold for a moment
Exhale slowly, releasing any tension

Now settle into your natural breathing pattern. Notice the sensation of air entering and leaving your body.

With each inhale, imagine drawing in calm and peace
With each exhale, imagine releasing any stress or tension

Continue this mindful breathing, letting each breath anchor you in the present moment.''',
          10: '''Settle into your seat and find a comfortable position. Allow your eyes to close or soften your gaze downward.

Begin with five deep, intentional breaths:
Inhale slowly through your nose, expanding your belly
Pause briefly at the top
Exhale completely through your mouth, releasing all tension

Now return to your natural breathing rhythm. Simply observe each breath without trying to change it.

Notice the cool air entering your nostrils on the inhale
Feel the warm air leaving on the exhale

When thoughts arise, acknowledge them kindly and return to your breath
Let each breath be an anchor to this moment of peace during your journey.'''
        },
        category: 'mindful_breath',
      ),

      // Body Scan for Travelers
      Practice(
        id: 'body_scan_travelers',
        title: 'Body Scan for Travelers',
        description: 'A body awareness practice to release travel tension',
        availableDurations: [2, 5, 10],
        compatibleModes: [TravelMode.car, TravelMode.train, TravelMode.flight, TravelMode.general],
        audioUrl: 'assets/audio/386_Music/ocean-shore-meditation-376918.mp3',
        practiceTextByDuration: {
          2: '''Sit comfortably and close your eyes.

Take a moment to notice how your body feels in this seat.

Starting from the top of your head, gently scan down through your body:
Notice any tension in your forehead, jaw, or neck
Feel the weight of your shoulders and arms
Notice your chest rising and falling with each breath
Feel your back against the seat
Notice your legs and feet

If you find any areas of tension, imagine breathing into them and releasing the tension with each exhale.''',
          5: '''Find a comfortable seated position and close your eyes.

Take three deep breaths to settle in.

Now we'll do a gentle body scan from head to toe:

Start with your head - notice any tension in your scalp, forehead, or around your eyes
Move to your face - feel your jaw, cheeks, and the muscles around your mouth
Notice your neck and throat - are they relaxed?
Feel your shoulders - let them drop if they're tense
Scan your arms - from shoulders to fingertips
Notice your chest and back - feel your breathing
Feel your abdomen - is it relaxed or tight?
Scan your legs - from hips to feet
Notice your feet - feel them grounded

As you scan each area, breathe into any tension and let it release with each exhale.''',
          10: '''Find a comfortable seated position and close your eyes.

Take several deep breaths to settle into your body.

We'll do a comprehensive body scan, spending time with each area:

Start with your head and face:
Notice your scalp - is it relaxed?
Feel your forehead - any furrows or tension?
Notice around your eyes - are they soft?
Feel your jaw - is it clenched or relaxed?
Notice your cheeks and mouth
Feel your neck and throat

Move to your upper body:
Feel your shoulders - let them drop away from your ears
Notice your arms - from shoulders to fingertips
Feel your chest - notice your breathing
Feel your back against the seat

Continue to your core:
Notice your abdomen - is it relaxed?
Feel your lower back
Notice your hips and pelvis

Finally, scan your legs:
Feel your thighs and knees
Notice your calves and ankles
Feel your feet - are they comfortable?

Take time with each area, breathing into any tension and releasing it.''',
        },
        category: 'body',
      ),

      // Travel Gratitude
      Practice(
        id: 'travel_gratitude',
        title: 'Travel Gratitude',
        description: 'Cultivate appreciation for your journey and the ability to travel',
        availableDurations: [2, 5, 10],
        compatibleModes: [TravelMode.car, TravelMode.train, TravelMode.flight, TravelMode.general],
        audioUrl: 'assets/audio/386_Music/spring-mornings-329796.mp3',
        practiceTextByDuration: {
          2: '''Close your eyes and take a few deep breaths.

Bring to mind three things you are grateful for in this moment:
Be grateful for your ability to travel and move through the world
Be grateful for the destination you are heading toward
Be grateful for this time you have to reflect and be present

Think of someone in your life you are grateful for, and send them loving thoughts.

Let this feeling of gratitude fill your heart as you continue your journey.''',
          5: '''Find a comfortable position and close your eyes. Take several deep breaths.

Let us cultivate gratitude for this journey:

First, gratitude for your physical experience:
Be grateful for your body that allows you to travel
For your senses that let you experience the world
For your breath that sustains you
For your heart that beats steadily

Now, gratitude for this moment:
For the opportunity to travel and explore
For the safety of your journey
For the technology or transport carrying you
For the time you have for reflection

Gratitude for the people in your life:
Think of someone who loves you - feel grateful for their presence in your life
Think of someone who has helped you - send them gratitude
Think of someone you're traveling to see or someone waiting for you

Gratitude for your experiences:
For the lessons you've learned
For the challenges that have made you stronger
For the joys you've experienced
For the growth that comes from travel and new experiences

Take a moment to feel this gratitude filling your entire being, and carry it with you on your journey.''',
          10: '''Find a comfortable position and close your eyes. Take several deep breaths.

Let us dive deep into gratitude for this journey and your life:

Begin with gratitude for your body:
Thank your legs that carry you through the world
Thank your arms that can hold and help
Thank your eyes that see beauty everywhere
Thank your ears that hear music and voices
Thank your heart that beats steadily
Thank your lungs that breathe life

Gratitude for your mind:
Thank your mind for its ability to learn and grow
For its capacity to solve problems
For its creativity and imagination
For its ability to remember and plan
For its resilience in difficult times

Gratitude for your journey:
Thank the road or path that carries you
Thank the vehicle or transport that moves you
Thank the people who built the infrastructure
Thank the technology that makes travel possible
Thank the safety systems that protect you

Gratitude for your destination:
Thank the place you're going
Thank the people you'll see
Thank the experiences awaiting you
Thank the purpose of your journey

Gratitude for the present moment:
Thank this time for reflection
Thank this opportunity for growth
Thank this moment of peace
Thank this chance to be present

Let this deep gratitude fill every cell of your body and carry you forward with joy.''',
        },
        category: 'gratitude',
      ),

      // Pre-Meeting Grounding
      Practice(
        id: 'pre_meeting_grounding',
        title: 'Pre-Meeting Grounding',
        description: 'A grounding practice before important meetings or events',
        availableDurations: [2, 5, 10],
        compatibleModes: [TravelMode.car, TravelMode.train, TravelMode.flight, TravelMode.general],
        audioUrl: 'assets/audio/386_Music/upbeat-lo-fi-instrumental-with-bright-chords-369296.mp3',
        practiceTextByDuration: {
          2: '''Take a moment to ground yourself before your meeting.

Feel your feet firmly planted on the ground, or your body solidly in your seat.

Take three deep breaths:
Inhale confidence and clarity
Hold for a moment
Exhale any nervousness or doubt

Imagine roots growing from your feet or seat, connecting you to the earth.

Feel your spine lengthening, your shoulders relaxed, your head held high.

You are grounded, centered, and ready for whatever comes next.''',
          5: '''Find a comfortable position and close your eyes.

Let us prepare your mind and body for what lies ahead:

Begin with deep, centering breaths:
Inhale calm and confidence
Exhale any anxiety or rushing energy
Continue breathing slowly and deeply

Bring to mind your upcoming meeting or arrival:
Who will you see?
What is the purpose?
How do you want to show up?

Set clear intentions:
I will be present and engaged
I will listen with an open heart
I will speak with clarity and kindness
I will remain calm and centered

Visualize the interaction going well:
See yourself arriving feeling grounded
Imagine positive connections and conversations
Picture yourself handling any challenges with grace

Take several more deep breaths, anchoring these intentions in your body.''',
          10: '''Find a comfortable seated position and close your eyes.

Let us thoroughly prepare your mind, body, and spirit for what lies ahead:

Begin with grounding breaths:
Inhale deeply, drawing in calm and confidence
Exhale slowly, releasing any tension or anxiety
Continue this rhythm for several breaths

Now, bring to mind your upcoming meeting or event:
Who will be there?
What is the purpose or goal?
What do you hope to accomplish?
How do you want to feel during and after?

Set powerful intentions:
I will be fully present and engaged
I will listen with an open heart and mind
I will speak with clarity, kindness, and confidence
I will remain calm and centered throughout
I will trust my preparation and abilities
I will handle any challenges with grace and wisdom

Visualize the entire experience:
See yourself arriving feeling grounded and confident
Imagine positive connections and meaningful conversations
Picture yourself handling any difficult moments with poise
See yourself leaving feeling satisfied and accomplished

Ground yourself physically:
Feel your feet firmly planted or your body solidly seated
Imagine roots growing from your feet or seat, connecting you to the earth
Feel your spine lengthening, your shoulders relaxed
Feel your head held high with confidence

Take several more deep breaths, anchoring all these intentions in your body.''',
        },
        category: 'preparation',
      ),

      // Let Go of the Rush
      Practice(
        id: 'let_go_rush',
        title: 'Let Go of the Rush',
        description: 'Release the urgency and stress of travel, finding peace in the journey',
        availableDurations: [2, 5, 10],
        compatibleModes: [TravelMode.car, TravelMode.train, TravelMode.flight, TravelMode.general],
        audioUrl: 'assets/audio/386_Music/lofi-chill-beat-lo-fi-postcard-366049.mp3',
        practiceTextByDuration: {
          2: '''Close your eyes and take a deep breath.

Notice any feelings of rush or urgency in your body
Where do you feel the stress of travel?
Breathe into those areas and let them soften

Remind yourself: You are exactly where you need to be right now
This journey is unfolding at the perfect pace
You have time for this moment of peace

Take slow, deliberate breaths and let the rush dissolve with each exhale.''',
          5: '''Find a comfortable position and close your eyes gently.

Let us release the urgency that often accompanies travel:

First, notice the rushing energy in your body:
Is your breathing shallow and quick?
Are your shoulders tense?
Is your mind racing ahead to your destination?

Begin to slow everything down:
Take deeper, slower breaths
Let your shoulders drop away from your ears
Bring your attention back to this present moment

Remind yourself of these truths:
You are exactly where you need to be right now
This journey is part of your day, not just a means to an end
You have permission to slow down and be present
Rushing rarely makes things go faster

With each exhale, release the need to hurry:
Breathe out impatience
Breathe out anxiety about timing
Breathe out the urge to control every detail

With each inhale, welcome in:
Patience with the process
Trust in the timing of your journey
Peace with the present moment''',
          10: '''Find a comfortable position and close your eyes gently.

Let us deeply release the urgency and stress that often accompanies travel:

Begin by noticing the rushing energy in your body:
Where do you feel tension or stress?
Is your breathing shallow and quick?
Are your muscles clenched?
Is your mind racing ahead?

Now, let's systematically slow everything down:

Start with your breath:
Take deeper, slower breaths
Inhale for 4 counts, hold for 2, exhale for 6
Let each breath be a reminder to slow down

Release physical tension:
Let your shoulders drop away from your ears
Relax your jaw and face
Unclench your hands
Let your legs be heavy and relaxed

Calm your mind:
Bring your attention back to this present moment
Notice what you can see, hear, and feel right now
Let go of thoughts about the destination
Focus on the journey itself

Remind yourself of these important truths:
You are exactly where you need to be right now
This journey is part of your life, not just a means to an end
You have permission to slow down and be present
Rushing rarely makes things go faster or better
The journey itself has value and meaning

With each exhale, release:
Impatience and urgency
Anxiety about timing
The need to control every detail
Stress about being late
The pressure to hurry

With each inhale, welcome in:
Patience with the process
Trust in the timing of your journey
Peace with the present moment
Gratitude for this time to reflect
Joy in the journey itself

Take time to feel this slower, more peaceful state.''',
        },
        category: 'stress_relief',
      ),
    ];
  }

  // Helper methods for filtering practices
  static List<Practice> getPracticesByCategory(String category) {
    return getPractices().where((practice) => practice.category == category).toList();
  }

  static List<Practice> getPracticesByTravelMode(TravelMode mode) {
    return getPractices().where((practice) => practice.isCompatibleWith(mode)).toList();
  }

  static List<Practice> getPracticesByDuration(int duration) {
    return getPractices().where((practice) => 
      practice.availableDurations.contains(duration)
    ).toList();
  }

  static Practice? getPracticeById(String id) {
    try {
      return getPractices().firstWhere((practice) => practice.id == id);
    } catch (e) {
      return null;
    }
  }
}
