// lib/models/training_data.dart

class ExVariation {
  final String name;
  final int sets;
  final String reps;
  final int restSeconds;

  const ExVariation({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });
}

class Exercise {
  final String name;
  final String icon;
  final List<ExVariation> variations;

  const Exercise({
    required this.name,
    required this.icon,
    required this.variations,
  });
}

class MuscleGroup {
  final String name;
  final List<Exercise> exercises;

  const MuscleGroup({required this.name, required this.exercises});
}

class TrainingDay {
  final String key;
  final String label;
  final String focus;
  final String time;
  final List<MuscleGroup> groups;

  const TrainingDay({
    required this.key,
    required this.label,
    required this.focus,
    required this.time,
    required this.groups,
  });
}

// ─── DADOS ───────────────────────────────────────────────
const List<TrainingDay> kTrainingDays = [
  TrainingDay(
    key: 'SEG', label: 'Segunda', focus: 'Peito + Tríceps', time: '55–65 min',
    groups: [
      MuscleGroup(name: 'Peito', exercises: [
        Exercise(name: 'Peitoral base', icon: 'PB', variations: [
          ExVariation(name: 'Supino reto',         sets: 4, reps: '8–12',  restSeconds: 90),
          ExVariation(name: 'Flexão de braço',     sets: 4, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Peitoral superior', icon: 'PS', variations: [
          ExVariation(name: 'Supino inclinado (45°)',  sets: 4, reps: '8–12',  restSeconds: 90),
          ExVariation(name: 'Flexão com pés elevados', sets: 4, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Peitoral maior', icon: 'PM', variations: [
          ExVariation(name: 'Crucifixo',       sets: 3, reps: '10–15', restSeconds: 60),
          ExVariation(name: 'Flexão arqueiro', sets: 3, reps: '10–12', restSeconds: 60),
        ]),
      ]),
      MuscleGroup(name: 'Tríceps', exercises: [
        Exercise(name: 'Tríceps base', icon: 'TB', variations: [
          ExVariation(name: 'Tríceps banco',        sets: 3, reps: '10–15', restSeconds: 60),
          ExVariation(name: 'Flexão mãos fechadas', sets: 3, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Tríceps alongado', icon: 'TA', variations: [
          ExVariation(name: 'Tríceps testa',              sets: 4, reps: '8–12',  restSeconds: 90),
          ExVariation(name: 'Extensão acima da cabeça',   sets: 3, reps: '10–12', restSeconds: 60),
        ]),
      ]),
    ],
  ),

  TrainingDay(
    key: 'TER', label: 'Terça', focus: 'Costas + Bíceps', time: '55–65 min',
    groups: [
      MuscleGroup(name: 'Costas', exercises: [
        Exercise(name: 'Costas base', icon: 'CB', variations: [
          ExVariation(name: 'Remada curvada',   sets: 4, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Remada invertida', sets: 4, reps: '8–12', restSeconds: 60),
        ]),
        Exercise(name: 'Costas controle', icon: 'CC', variations: [
          ExVariation(name: 'Remada unilateral',           sets: 4, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Remada invertida unilateral', sets: 3, reps: '8–12', restSeconds: 60),
        ]),
        Exercise(name: 'Costas largura', icon: 'CL', variations: [
          ExVariation(name: 'Pullover com halter', sets: 3, reps: '10–12', restSeconds: 60),
          ExVariation(name: 'Pulldown com toalha', sets: 3, reps: '10–15', restSeconds: 60),
        ]),
      ]),
      MuscleGroup(name: 'Bíceps', exercises: [
        Exercise(name: 'Bíceps base', icon: 'BB', variations: [
          ExVariation(name: 'Rosca direta com barra',  sets: 4, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Chin-up pegada supinada', sets: 4, reps: '6–10', restSeconds: 90),
        ]),
        Exercise(name: 'Bíceps pico', icon: 'BP', variations: [
          ExVariation(name: 'Rosca inclinada c/ halteres', sets: 3, reps: '10–12', restSeconds: 60),
          ExVariation(name: 'Chin-up pegada fechada',      sets: 4, reps: '6–10',  restSeconds: 90),
        ]),
        Exercise(name: 'Braquial', icon: 'BR', variations: [
          ExVariation(name: 'Rosca martelo',         sets: 3, reps: '10–12', restSeconds: 60),
          ExVariation(name: 'Chin-up pegada neutra', sets: 4, reps: '6–10',  restSeconds: 90),
        ]),
      ]),
    ],
  ),

  TrainingDay(
    key: 'QUA', label: 'Quarta', focus: 'Pernas', time: '50–60 min',
    groups: [
      MuscleGroup(name: 'Pernas', exercises: [
        Exercise(name: 'Quadríceps', icon: 'QD', variations: [
          ExVariation(name: 'Agachamento búlgaro', sets: 3, reps: '8–10', restSeconds: 60),
          ExVariation(name: 'Pistol squat',        sets: 4, reps: '4–8',  restSeconds: 90),
        ]),
        Exercise(name: 'Posterior de coxa', icon: 'PC', variations: [
          ExVariation(name: 'Terra romeno', sets: 4, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Nordic curl',  sets: 3, reps: '6–10', restSeconds: 90),
        ]),
        Exercise(name: 'Unilateral', icon: 'UN', variations: [
          ExVariation(name: 'Afundo com halteres', sets: 3, reps: '10–12', restSeconds: 60),
          ExVariation(name: 'Afundo andando',      sets: 3, reps: '10–12', restSeconds: 60),
        ]),
        Exercise(name: 'Panturrilha', icon: 'PA', variations: [
          ExVariation(name: 'Panturrilha em pé c/ peso', sets: 4, reps: '12–20', restSeconds: 60),
          ExVariation(name: 'Panturrilha unilateral',    sets: 3, reps: '12–20', restSeconds: 60),
        ]),
      ]),
    ],
  ),

  TrainingDay(
    key: 'QUI', label: 'Quinta', focus: 'Ombro', time: '45–55 min',
    groups: [
      MuscleGroup(name: 'Ombro', exercises: [
        Exercise(name: 'Deltoide anterior', icon: 'DA', variations: [
          ExVariation(name: 'Desenvolvimento', sets: 4, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Pike push-up',   sets: 4, reps: '8–12', restSeconds: 60),
        ]),
        Exercise(name: 'Deltoide lateral', icon: 'DL', variations: [
          ExVariation(name: 'Elevação lateral c/ halteres', sets: 3, reps: '10–15', restSeconds: 60),
          ExVariation(name: 'Elevação lateral inclinada',   sets: 3, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Deltoide posterior', icon: 'DP', variations: [
          ExVariation(name: 'Crucifixo inverso c/ halteres', sets: 3, reps: '10–15', restSeconds: 60),
          ExVariation(name: 'Reverse plank raise',           sets: 3, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Trapézio superior', icon: 'TS', variations: [
          ExVariation(name: 'Encolhimento c/ halteres',  sets: 3, reps: '10–15', restSeconds: 60),
          ExVariation(name: 'Encolhimento isométrico',   sets: 3, reps: '20–30s', restSeconds: 60),
        ]),
      ]),
    ],
  ),

  TrainingDay(
    key: 'SEX', label: 'Sexta', focus: 'Full Body', time: '45–60 min',
    groups: [
      MuscleGroup(name: 'Full Body', exercises: [
        Exercise(name: 'Peito', icon: 'PE', variations: [
          ExVariation(name: 'Supino reto',      sets: 3, reps: '8–12',  restSeconds: 90),
          ExVariation(name: 'Flexão de braço',  sets: 3, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Tríceps', icon: 'TR', variations: [
          ExVariation(name: 'Tríceps testa',        sets: 3, reps: '8–12',  restSeconds: 90),
          ExVariation(name: 'Flexão mãos fechadas', sets: 3, reps: '10–15', restSeconds: 60),
        ]),
        Exercise(name: 'Costas', icon: 'CO', variations: [
          ExVariation(name: 'Remada curvada',   sets: 3, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Remada invertida', sets: 3, reps: '8–12', restSeconds: 60),
        ]),
        Exercise(name: 'Bíceps', icon: 'BI', variations: [
          ExVariation(name: 'Rosca direta com barra',       sets: 3, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Remada inv. pegada supinada',  sets: 3, reps: '8–12', restSeconds: 60),
        ]),
        Exercise(name: 'Ombro', icon: 'OM', variations: [
          ExVariation(name: 'Desenvolvimento', sets: 3, reps: '8–12', restSeconds: 90),
          ExVariation(name: 'Pike push-up',    sets: 3, reps: '8–12', restSeconds: 60),
        ]),
        Exercise(name: 'Pernas', icon: 'PG', variations: [
          ExVariation(name: 'Agachamento búlgaro', sets: 3, reps: '8–10', restSeconds: 90),
          ExVariation(name: 'Pistol squat',        sets: 3, reps: '4–8',  restSeconds: 90),
        ]),
        Exercise(name: 'Panturrilha', icon: 'PT', variations: [
          ExVariation(name: 'Panturrilha em pé c/ peso', sets: 3, reps: '12–20', restSeconds: 60),
          ExVariation(name: 'Panturrilha unilateral',    sets: 3, reps: '12–20', restSeconds: 60),
        ]),
      ]),
    ],
  ),
];

const List<String> kQuotes = [
  'A dor de hoje é a força de amanhã.',
  'Cada série te aproxima da melhor versão.',
  'Disciplina supera motivação.',
  'O único mau treino é o que não aconteceu.',
  'Foco, força e fé.',
  'Supere seus limites, um rep de cada vez.',
  'Resultados exigem consistência.',
  'Não pare quando estiver cansado — pare quando terminar.',
  'Hoje é um bom dia para ser forte.',
  'Cada treino é um depósito no banco do seu futuro.',
];
