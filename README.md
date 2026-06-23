# Estudos App

Aplicativo mobile de produtividade pessoal que centraliza tarefas, agenda e sessões de foco em um único painel diário, desenvolvido como entrega da Atividade Ponderada 4 do Módulo 10 de Engenharia da Computação.

Vídeo de demonstração da solução: https://youtu.be/-GF2zJQojiA


## Problema

Esse projeto nasceu de uma dor minha, como estudante, na busca constante por diferentes ferramentas de estudo que possam ajudar na organização e produtividade. Há alguns anos, no ensino médio, eu já vivia o problema que esse app resolve: eu usava um app para listar tarefas, outro para ver minha agenda, outro para cronometrar sessões de estudo no método Pomodoro, e mais um ou dois para outras coisas pontuais. E com a grande variedade de aplicativos, ao longo do tempo acabei mais gerenciando ferramentas do que a minha própria rotina.

Na época eu não tinha conhecimento técnico para resolver isso sozinha, então a ideia ficou guardada. Hoje, utilizando os conhecimentos que obtive no módulo, decidi retomar essa ideia de projeto para a entrega da ponderada. A ideia era construir a solução que eu mesmo queria ter tido: um lugar só para abrir de manhã e saber exatamente o que tenho que fazer no dia, sem precisar trocar de app três ou quatro vezes para realizar esse gerenciamento.

## Solução

O Estudos App é um hub diário que centraliza as principais funcionalidades utilizadas no dia a dia de um estudante. Ao abrir o app, é possível ver imediatamente:

- **O que tem agendado para hoje**, sincronizado diretamente do Google Calendar (considerando todos os calendários da conta, não apenas o principal);
- **Quais tarefas estão pendentes**, criadas e gerenciadas dentro do próprio app;
- **Um botão para compartilhar o resumo do dia** — tarefas concluídas e minutos de foco acumulados, com qualquer app de mensagens ou rede social.

Além do painel central, o app conta com um módulo de Tarefas completo (criar, editar, concluir, excluir) e um módulo de Timer de Foco no modelo Pomodoro, que dispara notificação e vibração do aparelho ao final de cada ciclo e persiste o histórico de sessões (exatamente o tipo de cronômetro que eu mais usava naquela época).

## Plataforma

Este projeto foi desenvolvido e testado **exclusivamente para Android**.  Flutter foi escolhido por permitir, no futuro, expansão para iOS a partir da mesma base de código, mas essa expansão não fez parte do escopo desta entrega.

## Funcionalidades e requisitos atendidos

| Requisito da ponderada | Como foi implementado |
|---|---|
| Implementação mobile | Flutter (Dart), buildado e testado em emulador Android via Android Studio |
| Múltiplas telas com navegação | Login → Painel (Dashboard) → Tarefas → Timer de Foco, conectadas por bottom navigation bar |
| Backend funcional | Supabase (autenticação via Google OAuth + tabela `tasks` sincronizada) |
| Banco de dados | Drift (SQLite local) para persistência offline-first + Supabase como espelho remoto |
| API externa | Google Calendar API, busca eventos de **todos** os calendários da conta autenticada, não apenas o principal |
| Sistema de notificações | Notificação local (`flutter_local_notifications`) disparada ao término de cada sessão Pomodoro |
| Compartilhamento | `share_plus`, compartilha resumo do dia (tarefas concluídas + minutos de foco) via apps nativos do Android |
| Uso de hardware do dispositivo | Vibração (`vibration`) acionada junto à notificação de fim de sessão|

## Arquitetura

O projeto segue os princípios da **Clean Architecture**, organizados em três camadas com regra de dependência única: camadas externas conhecem camadas internas.

```
Presentation  →  Domain  →  Data
 (Flutter UI)    (regras)   (Drift / Supabase / Google API)
```

- **Domain**: entidades puras (`Task`, `FocusSessionEntity`), interfaces de repositório (`ITaskRepository`, `IFocusSessionRepository`) e use cases (`CreateTask`, `CompleteTask`, `GetTodayEvents`, etc). Esta camada não conhece Flutter, Drift ou Supabase.
- **Data**: implementações concretas dos repositórios, DAOs do Drift e datasources que conversam com Supabase e Google Calendar API.
- **Presentation**: telas Flutter e providers Riverpod, que consomem apenas use cases, nunca acessam banco de dados ou APIs diretamente.

Essa separação permite, por exemplo, trocar o Drift por outro banco local, ou o Supabase por outro backend, sem alterar uma linha da camada de apresentação.

### Por que duas fontes de dados para tarefas (Drift + Supabase)?

O app é **local-first**: toda operação de tarefa acontece primeiro no banco local (Drift), garantindo que o app funcione mesmo sem internet. Em seguida, a mesma operação é replicada no Supabase como uma camada de backend/nuvem, cumprindo o requisito de backend funcional da atividade e preparando o terreno para sincronização entre dispositivos em versões futuras.

## Stacks e justificativas

| Tecnologia | Papel no projeto | Por que foi escolhida |
|---|---|---|
| **Flutter / Dart** | Framework mobile | Permite um único código-base para Android e, futuramente, iOS |
| **Riverpod** | Gerenciamento de estado | Não depende de `BuildContext`, é testável fora da árvore de widgets e escala bem conforme o app cresce |
| **Drift** | Banco de dados local (SQLite) | ORM type-safe: erros de coluna/tipo aparecem em tempo de compilação, não em produção |
| **Freezed** | Imutabilidade de entidades | Gera `copyWith`, `==` e `toString` automaticamente, eliminando uma classe inteira de bugs de mutação |
| **Supabase** | Backend / autenticação / banco remoto | BaaS open-source com autenticação OAuth pronta e API REST automática sobre PostgreSQL, não exige escrever um servidor próprio |
| **Google Calendar API** | API externa | Diretamente relacionada à proposta do app (agenda do dia); usa OAuth 2.0 via `google_sign_in` |
| **flutter_local_notifications** | Notificações locais | Suporte nativo Android/iOS sem necessidade de servidor de push |
| **vibration** | Hardware do dispositivo | Feedback tátil simples e não-intrusivo para o fim do Pomodoro |
| **share_plus** | Compartilhamento | Usa o share sheet nativo do Android, sem reinventar UI de compartilhamento |


O uso de bibliotecas como Riverpod, Drift e Freezed foi feito a partir de um estudo sobre o ecossistema Flutter, pensando em escalar o código dessa atividade futuramente, expandindo para IOS e adicionando novas funcionalidades. Com essas bibliotecas, foi possível fazer um código com arquitetura limpa, estado previsível e persistência confiável.

## Como executar o projeto

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado (`flutter doctor` sem erros críticos)
- Android Studio com um emulador Android configurado (ou um dispositivo físico Android com depuração USB ativada)
- Uma conta Google para testar o login e a sincronização de agenda

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/lupetenazzi/estudos_app.git
cd estudos_app

# 2. Instale as dependências
flutter pub get

# 3. Gere os arquivos de código (Drift e Freezed)
dart run build_runner build --delete-conflicting-outputs

# 4. Rode o projeto em um emulador ou dispositivo conectado
flutter run
```

IMPORTANTE: é necessário executar o aplicativo em um emulador do Android Studio, pois no momento ele só é compatível para android

### Configuração de variáveis sensíveis

O projeto utiliza Supabase e Google Sign-In. As credenciais necessárias (URL e chave anônima do Supabase, Client ID OAuth do Google) estão configuradas em:

- `lib/main.dart` — inicialização do Supabase
- `android/app/src/main/res/values/strings.xml` — `default_web_client_id` do Google Sign-In

Entende-se que para a escalabilidade desse projeto futuramente, essas credenciais devem ser migradas para um ambiente controlado, removendo essa exposição atual. Porém pensando em praticidade de avaliação e execução do projeto, preferi manter dessa forma até o momento.

## Estrutura de pastas

```
lib/
├── data/
│   ├── datasources/      # Supabase, Google Calendar API
│   ├── local/            # Banco de dados Drift (tabelas, DAOs)
│   ├── models/           # Mapeamento entre entidades de domínio e dados
│   └── repositories/     # Implementações concretas dos repositórios
├── domain/
│   ├── entities/         # Task, FocusSessionEntity, AxisEntity
│   ├── repositories/     # Interfaces (contratos)
│   └── usecases/         # Regras de negócio (CreateTask, GetTodayEvents...)
├── presentation/
│   ├── auth/             # Tela de login (Google)
│   ├── dashboard/        # Painel diário (agenda + tarefas + compartilhar)
│   ├── tasks/            # Módulo de tarefas
│   ├── timer/            # Módulo de timer de foco
│   └── main_page.dart    # Bottom navigation entre os módulos
├── services/             # Serviços auxiliares (notificações)
├── theme/                # Design system (cores, tipografia)
└── main.dart             # Ponto de entrada da aplicação
```

## Identidade visual

A identidade visual e o protótipo de navegação do app foram explorados previamente no **Figma Make**, uma ferramenta de geração de interfaces assistida por IA, antes do início da implementação em Flutter. Essa etapa ajudou a validar o fluxo de telas (Login → Painel → Tarefas → Timer) e a paleta de cores (roxo/lilás como cor primária, laranja como acento) que foi posteriormente traduzida para o `ThemeData` do Flutter.

**Prompt utilizado no Figma Make:**

```bash

Crie o design de um app mobile chamado "Estudos App" — um organizador de produtividade para estudantes universitários. O app tem personalidade focada mas acolhedora: não é frio e corporativo, nem infantil. Pensa num estudante que quer se sentir no controle da sua rotina.

Identidade visual: pode ser criativo no uso das cores, desde que as cores façãm sentido em conjunto. Tipografia moderna e limpa — sem serifa. Bordas arredondadas, cards com sombra leve, muito espaço em branco. Estética entre o Notion e o Duolingo — organizado mas com vida.

Telas a criar:

Splash + Biometria — tela simples com logo/nome do app e um ícone de impressão digital ou rosto para autenticação biométrica

Login / Cadastro — campos de e-mail e senha, botão de entrar, link para cadastro. Limpo e convidativo

Painel Diário — tela principal. Mostra: saudação com nome do usuário, cards de tarefas pendentes do dia, progresso do timer de foco (ex: "2 de 4 pomodoros"), eventos do Google Calendar do dia, e um botão de compartilhar resumo diário

Tarefas — lista de tarefas com checkbox, botão de adicionar nova tarefa, filtro por status (pendente/concluída). Cards simples com título, data e prioridade

Timer de Foco — timer circular grande no centro, botão de iniciar/pausar, opção de escolher modo Pomodoro (25min) ou livre. Indicador de quantos ciclos foram feitos

Perfil do Usuário — foto, nome, e-mail, estatísticas simples (tarefas concluídas, horas de foco), botão de logout


Componentes para criar: botão primário, botão secundário, card de tarefa, input de texto, chip de status, barra de navegação inferior com 4 ícones (Painel, Tarefas, Timer, Perfil)
Referências de estilo: Notion, Linear, Duolingo — minimalista com personalidade. Não quero dark mode, só light.

```


**Link do protótipo / visualização esperada:**

> https://www.figma.com/make/Tx4HXb8hrzJbmnizuCRPdv/Estudos-App-Design?t=ovpdOiXRPF7bvjgv-1

## Uso de Inteligência Artificial no desenvolvimento

Este projeto contou com apoio de IA (Claude, da Anthropic) em três frentes principais, sempre como ferramenta de apoio à decisão .

1. **Definição de escopo e arquitetura.** A IA atuou como consultora para transformar uma ideia inicial ampla (um "super-app" de produtividade com flashcards, hábitos, bloqueio de apps, etc.) em um escopo viável para a entrega da ponderada, identificando quais funcionalidades do plano original já atendiam aos requisitos da atividade e quais precisavam ser adicionadas (backend, compartilhamento, uso de hardware).

2. **Revisão de Clean Code e Clean Architecture.** Ao longo do desenvolvimento, trechos de código foram enviados para revisão, com a IA apontando violações da regra de dependência entre camadas (por exemplo, um use case importando diretamente uma classe da camada de dados), inconsistências no tratamento de erros entre repositórios, e código morto a ser documentado ou removido.

3. **Adaptação de código e correção de erros.** Em pontos específicos, como a integração OAuth entre Google Sign-In e Supabase, a configuração de múltiplos Client IDs no Google Cloud Console, e bugs de UI (overflow de texto, conflito de gestos de scroll), a IA ajudou a diagnosticar a causa raiz e sugerir a correção, que foi então implementada e testada manualmente.

Também foi utilizada a IA do **Figma Make** na etapa de pré-construção, para explorar visualmente a identidade do app e o fluxo de navegação antes de qualquer linha de código Flutter ser escrita.

## Limitações conhecidas e próximos passos

Estas são decisões conscientes de escopo para a entrega da ponderada, já mapeadas para uma v2 do projeto:

- **Eixos de organização (`AxisEntity`)**: a estrutura de dados já existe no banco, mas a categorização de tarefas por contexto (estudo/trabalho/pessoal) ainda não está exposta na interface.
- **Sincronização bidirecional**: hoje o app envia dados para o Supabase, mas não busca de volta em caso de troca de dispositivo.
- **Modo livre do timer**: a estrutura de dados já contempla o campo `mode`, mas a interface atual oferece apenas o modo Pomodoro fixo de 25 minutos.
- **Relatórios e histórico visual**: as sessões de foco já são persistidas, mas ainda não há uma tela de visualização de progresso (gráficos, heatmap) planejada para a próxima fase do projeto.

No fim das contas, essa entrega é a v0 de um projeto que pretendo continuar desenvolvendo depois da ponderada, com calma, agregando o restante das funcionalidades que eu já tinha desenhado desde o início.