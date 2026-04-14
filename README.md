# 💪 Meu Treino — Flutter App

Aplicativo de cronograma de treino com timer de descanso, séries, variações e animações.

---

## 📁 Estrutura do Projeto

```
treino_flutter/
├── codemagic.yaml                        ← CI/CD (Codemagic)
├── pubspec.yaml                          ← Dependências Flutter
│
├── lib/
│   ├── main.dart                         ← Entrada do app
│   ├── models/
│   │   └── training_data.dart            ← Dados dos treinos
│   ├── services/
│   │   ├── app_theme.dart                ← Tema e cores
│   │   └── timer_service.dart            ← Lógica do timer (Provider)
│   ├── screens/
│   │   ├── home_screen.dart              ← Tela inicial (dias)
│   │   └── workout_screen.dart           ← Tela do treino
│   └── widgets/
│       ├── exercise_card_widget.dart     ← Card de exercício
│       └── float_timer_widget.dart       ← Timer flutuante
│
└── android/
    ├── build.gradle
    ├── settings.gradle
    ├── gradle.properties
    ├── gradle/wrapper/
    │   └── gradle-wrapper.properties
    └── app/
        ├── build.gradle
        └── src/main/
            ├── AndroidManifest.xml
            ├── kotlin/com/meutreino/app/
            │   └── MainActivity.kt
            └── res/
                ├── drawable/
                │   └── launch_background.xml
                └── values/
                    └── styles.xml
```

---

## 🚀 Passo a passo — do zero ao Codemagic

### 1. Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
- [Git](https://git-scm.com/) instalado
- Conta no [GitHub](https://github.com) (gratuita)
- Conta no [Codemagic](https://codemagic.io) (gratuita)

### 2. Testar localmente (opcional mas recomendado)
```bash
cd treino_flutter
flutter pub get
flutter run
```

### 3. Criar repositório no GitHub
```bash
cd treino_flutter
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/treino-app.git
git push -u origin main
```

### 4. Conectar ao Codemagic
1. Entre em [codemagic.io](https://codemagic.io)
2. Clique em **"Add application"**
3. Conecte sua conta do GitHub
4. Selecione o repositório `treino-app`
5. Escolha **Flutter App**
6. Clique em **"Check for configuration file"** (ele vai encontrar o `codemagic.yaml`)

### 5. Iniciar o build
- Escolha o workflow **"Android Debug (sem assinatura)"** para testar
- Clique em **"Start new build"**
- Aguarde ~10 minutos
- Baixe o `.apk` gerado e instale no celular

---

## 📱 Instalar o APK no Android
1. No celular: **Configurações → Segurança → Fontes desconhecidas** (habilitar)
2. Transfira o `.apk` para o celular (WhatsApp, e-mail, Google Drive)
3. Abra o arquivo e instale

---

## 🔑 Para publicar na Play Store (futuro)
1. Gere uma keystore:
```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```
2. No Codemagic → Settings → Code Signing → adicione a keystore
3. Use o workflow `android-release` no `codemagic.yaml`

---

## ✨ Funcionalidades
- 📅 5 dias de treino (Seg, Ter, Qua, Qui, Sex)
- 💪 Exercícios com variação principal e alternativa
- ✅ Checkboxes por série com animação
- ⏱ Timer de descanso com relógio circular animado
- 🔔 Timer flutuante sobreposto a qualquer tela
- 🏆 Tela de celebração ao concluir o treino
- 💬 Frases motivacionais rotativas
- 🌙 Tema escuro com design glassmorphism
