# DevOps Lab AWS

Este repositório contém um projeto laboratorial que integra **GitHub, Docker, Terraform, Jenkins e Postman** em uma pipeline completa de DevOps na **AWS**.

## Estrutura
- `app/` → Aplicação exemplo (API Hello World).
- `infra/` → Infraestrutura como Código (Terraform).
- `tests/` → Testes automatizados (Postman/Newman).
- `.github/workflows/` → Pipelines (GitHub Actions) — a partir do Dia 2.

## Objetivo
Ao longo de 10 dias, evoluiremos este projeto até termos um pipeline completo:
1. Versionamento (GitHub)
2. Testes (Postman)
3. Containerização (Docker)
4. Provisionamento (Terraform, AWS)
5. CI/CD (Jenkins)

## Requisitos
- Git, Docker, Terraform, Jenkins, Postman
- Conta AWS e GitHub

## Como contribuir
- Crie branchs por feature (ex.: feature/day1-setup)
- Faça commits descritivos (padrão Conventional Commits é bem-vindo)
- Abra Pull Requests com descrição do que foi alterado
