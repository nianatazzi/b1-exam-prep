// Разово загружает тестовый контент image_description (Фаза 1) в Firestore.
// Использование: см. scripts/seed/README.md
const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

const serviceAccount = require('./serviceAccountKey.json');
const data = JSON.parse(
  fs.readFileSync(path.join(__dirname, 'seed-data.json'), 'utf8'),
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seedSections(sections) {
  for (const section of sections ?? []) {
    const sectionRef = db
      .collection('b1_polish')
      .doc('pl')
      .collection('sections')
      .doc(section.id);
    await sectionRef.set(section.data);
    console.log(`section: ${section.id}`);

    for (const topic of section.topics ?? []) {
      const topicRef = sectionRef.collection('topics').doc(topic.id);
      await topicRef.set(topic.data);
      console.log(`  topic: ${topic.id}`);

      for (const rule of topic.grammar ?? []) {
        await topicRef.collection('grammar').doc(rule.id).set(rule.data);
        console.log(`    grammar: ${rule.id}`);
      }

      for (const vocab of topic.vocabulary ?? []) {
        await topicRef.collection('vocabulary').doc(vocab.id).set(vocab.data);
        console.log(`    vocabulary: ${vocab.id}`);
      }

      for (const phrase of topic.phrases ?? []) {
        await topicRef.collection('phrases').doc(phrase.id).set(phrase.data);
        console.log(`    phrase: ${phrase.id}`);
      }
    }
  }
}

async function seedExercises(exercises) {
  for (const exercise of exercises ?? []) {
    await db.collection('exercises').doc(exercise.id).set(exercise.data);
    console.log(`exercise: ${exercise.id}`);
  }
}

async function main() {
  await seedSections(data.sections);
  await seedExercises(data.exercises);
  console.log('Done.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
