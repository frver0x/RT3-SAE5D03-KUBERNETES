# Contribuer

## Rôles

| Rôle | Qui | Responsabilités |
|---|---|---|
| Commanditaire (MOA) | Kubenstein Inc, représenté par les encadrants | Exprime le besoin, valide les comptes-rendus, chaque jalon et la recette |
| Product Owner | Valentin | Porte le besoin du client dans l'équipe, tient et priorise le backlog, découpe les lots en tâches, vérifie la Definition of Done |
| Scrum Master | Pierre | Anime les points d'équipe, lève les blocages, suit le temps passé, devis et bilan financier |
| Équipe R&T (MOE) | Alexandre, Romain, Valentin, Pierre | Réalise les tâches de son lot (voir l'arborescence) |

## Méthode

Approche hybride, comme dans le cahier des charges :

- les **jalons** J1 à J4 sont fixés par rétroplanning (milestones GitHub) ;
- le travail avance par **sprints** calés sur les semaines de SAE ; chaque sprint se termine par une démonstration au client ;
- le daily est remplacé par un **point court au début de chaque journée de SAE** ;
- la **revue de sprint** a lieu au rendez-vous client, la **rétrospective** (ce qui a marché, ce qui a échoué) est notée dans le compte-rendu.

| Sprint | Période | Jalon visé |
|---|---|---|
| Sprint 1 | 30/11 au 04/12/2026 | J1 · Cluster 1+1 |
| Asynchrone | 07/12/2026 au 15/01/2027 | Préparation (CI, Vault, Velero) |
| Sprint 2 | 18/01 au 22/01/2027 | J2 · Cluster complet |
| Sprint 3 | 25/01 au 29/01/2027 | J3 · Upgrade 1.31, J4 · Démo et rendu |

## Priorités (MoSCoW)

Le champ **Priority** du projet suit MoSCoW : **P0 = Must**, **P1 = Should**, **P2 = Could**. Ce qui est exclu (Won't) n'entre pas dans le backlog, il est noté dans le compte-rendu.

## Suivi des tâches

- Une issue par tâche, rattachée à son lot (sous-issue) et à un jalon.
- Chaque issue a un **critère d'acceptation** vérifiable (une commande et son résultat attendu) et une estimation (champ **Estimate**, en heures).
- En fin de tâche, renseigner **Temps passé (h)** : il sert au suivi estimé / réel et au bilan financier.
- Toute nouvelle demande du client va dans le backlog, priorisée en MoSCoW et tracée dans le compte-rendu.

## Definition of Done

Une tâche est terminée quand son code est **relu par un autre membre**, **testé**, **documenté** et **intégré à `main`**.

## Branches et commits

- `main` est protégée : toujours une pull request, relue par le responsable du lot (voir `.github/CODEOWNERS`).
- Une branche par issue : `feat/12-cilium`, `fix/20-metallb-pool`, `docs/31-pra`.
- Messages au format [Conventional Commits](https://www.conventionalcommits.org/fr/) : `feat(ceph): add default StorageClass`, `fix(vault): …`, `docs(pra): …`.
- Un tag par jalon : `v0.1.0` (J1), `v0.2.0` (J2), `v0.3.0` (J3), `v1.0.0` (J4).

## Arborescence prévue

| Dossier | Contenu | Responsable |
|---|---|---|
| `infra/` | OpenTofu (OpenStack) et Ansible | Alexandre |
| `cluster/` | Configuration kubeadm, kube-vip, upgrade | Alexandre |
| `platform/network/` | Cilium, MetalLB, cert-manager, Gateway API | Romain |
| `platform/monitoring/` | kube-prometheus-stack, Grafana, Loki | Romain |
| `platform/storage/` | Rook-Ceph | Pierre |
| `platform/vault/` | Vault HA, External Secrets | Pierre / Valentin |
| `platform/backup/` | Velero, MinIO, snapshots etcd | Pierre |
| `gitops/` | ArgoCD, app-of-apps | Valentin |
| `docs/` | Documentation, ADR, comptes-rendus, devis | Tous |

## Décisions et échanges

- Toute décision technique structurante est écrite dans `docs/adr/` à partir de `0000-modele.md`.
- Chaque rendez-vous client donne un compte-rendu dans `docs/comptes-rendus/` (modèle fourni), envoyé au client et approuvé par courriel.

## Secrets

Jamais de secret en clair dans le repo (fichiers `*-openrc.sh`, tokens Vault, kubeconfig). Les secrets passent par Vault et External Secrets.
