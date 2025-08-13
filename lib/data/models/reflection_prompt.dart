import 'package:hive/hive.dart';

part 'reflection_prompt.g.dart';

@HiveType(typeId: 8)
class ReflectionPrompt extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int order;

  ReflectionPrompt({
    required this.id,
    required this.question,
    required this.category,
    required this.order,
  });

  static List<ReflectionPrompt> getDefaultPrompts() {
    return [
      ReflectionPrompt(
        id: 'feeling_now',
        question: 'How do you feel now?',
        category: 'post_practice',
        order: 1,
      ),
      ReflectionPrompt(
        id: 'mind_before',
        question: 'What was on your mind before this practice?',
        category: 'post_practice',
        order: 2,
      ),
      ReflectionPrompt(
        id: 'gratitude_today',
        question: 'What are you grateful for today?',
        category: 'post_practice',
        order: 3,
      ),
      ReflectionPrompt(
        id: 'travel_intention',
        question: 'What intention do you want to set for this journey?',
        category: 'pre_travel',
        order: 1,
      ),
      ReflectionPrompt(
        id: 'arrival_feeling',
        question: 'How do you want to feel when you arrive?',
        category: 'pre_travel',
        order: 2,
      ),
    ];
  }
}

@HiveType(typeId: 9)
enum MoodTag {
  @HiveField(0)
  calm('calm', '😌', 'Calm'),
  
  @HiveField(1)
  focused('focused', '🎯', 'Focused'),
  
  @HiveField(2)
  relaxed('relaxed', '😊', 'Relaxed'),
  
  @HiveField(3)
  grateful('grateful', '🙏', 'Grateful'),
  
  @HiveField(4)
  energized('energized', '⚡', 'Energized'),
  
  @HiveField(5)
  peaceful('peaceful', '☮️', 'Peaceful'),
  
  @HiveField(6)
  distracted('distracted', '😵‍💫', 'Distracted'),
  
  @HiveField(7)
  anxious('anxious', '😰', 'Anxious'),
  
  @HiveField(8)
  tired('tired', '😴', 'Tired'),
  
  @HiveField(9)
  restless('restless', '😤', 'Restless');

  const MoodTag(this.id, this.emoji, this.displayName);

  final String id;
  final String emoji;
  final String displayName;
}
