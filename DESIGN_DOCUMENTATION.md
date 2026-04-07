# Maya E-Wallet - Design Documentation

This document provides architectural design, class diagrams, and sequence diagrams for the Maya E-Wallet application.

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Class Diagrams](#class-diagrams)
   - [Authentication Feature](#authentication-feature)
   - [Wallet Feature](#wallet-feature)
   - [Transaction Feature](#transaction-feature)
3. [Sequence Diagrams](#sequence-diagrams)
   - [User Login Flow](#user-login-flow)
   - [Send Money Flow](#send-money-flow)
   - [Cash In Flow](#cash-in-flow)
   - [Load Transactions Flow](#load-transactions-flow)

---

## Architecture Overview

### Layered Architecture

The application follows **Clean Architecture** principles with three distinct layers:

```
┌─────────────────────────────────────────────────────┐
│                PRESENTATION LAYER                   │
│  Screens, Widgets, Cubits (State Management)        │
│                                                     │
│  ┌────────────────┬──────────────┬───────────────┐ │
│  │ Auth Feature   │ Wallet       │ Transaction   │ │
│  │ Screens        │ Feature      │ Feature       │ │
│  │ + Cubits       │ Screens      │ Screens       │ │
│  │ + Widgets      │ + Cubits     │ + Cubits      │ │
│  └────────────────┴──────────────┴───────────────┘ │
└──────────────────┬──────────────────────────────────┘
                   │ Depends on
┌──────────────────▼──────────────────────────────────┐
│                 DOMAIN LAYER                        │
│  Business Logic, Entities, Use Cases, Contracts    │
│                                                     │
│  ┌──────────────┬──────────────┬────────────────┐  │
│  │ Auth Domain  │ Wallet       │ Transaction    │  │
│  │ - User       │ Domain       │ Domain         │  │
│  │ - LoginUC    │ - Wallet     │ - Transaction  │  │
│  │ - AuthRepo   │ - *UCs       │ - *UCs         │  │
│  │              │ - WalletRepo │ - TransRepo    │  │
│  └──────────────┴──────────────┴────────────────┘  │
└──────────────────┬──────────────────────────────────┘
                   │ Depends on
┌──────────────────▼──────────────────────────────────┐
│                 DATA LAYER                          │
│  Repository Implementations, Models, Data Sources  │
│                                                     │
│  ┌──────────────┬──────────────┬────────────────┐  │
│  │ Auth Data    │ Wallet Data  │ Transaction    │  │
│  │ - AuthRepoI  │ - WalletRepoI│ Data           │  │
│  │ - LocalDS    │ - LocalDS    │ - TransRepoI   │  │
│  │ - PwdUtils   │ - Model      │ - RemoteDS     │  │
│  │ - Model      │              │ - Model        │  │
│  └──────────────┴──────────────┴────────────────┘  │
└──────────────────────────────────────────────────────┘
```

### Design Patterns Used

| Pattern | Purpose | Location |
|---------|---------|----------|
| **Repository** | Abstract data source implementation | All features |
| **Use Case** | Encapsulate business logic | Domain layer |
| **Entity-Model** | Separate domain entities from data models | All features |
| **BLoC/Cubit** | Reactive state management | Presentation layer |
| **Dependency Injection** | Loose coupling, testability | `main.dart` |
| **Go Router** | Navigation with auth guards | `lib/core/routing/` |

---

## Class Diagrams

### Authentication Feature

```
┌─────────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                         │
└─────────────────────────────────────────────────────────────┘

                      ┌──────────────┐
                      │ LoginScreen  │
                      └──────┬───────┘
                             │ uses
                    ┌────────▼─────────┐
                    │  AuthCubit       │
                    ├──────────────────┤
                    │ - authRepository │
                    ├──────────────────┤
                    │ + login()        │
                    │ + logout()       │
                    └────────┬─────────┘
                             │ emits
                    ┌────────▼─────────────────┐
                    │ AuthState (Abstract)     │
                    ├──────────────────────────┤
                    │ + AuthInitial            │
                    │ + AuthLoading            │
                    │ + AuthSuccess(User)      │
                    │ + AuthFailure(message)   │
                    └──────────────────────────┘


┌─────────────────────────────────────────────────────────────┐
│                   DOMAIN LAYER                              │
└─────────────────────────────────────────────────────────────┘

              ┌──────────────────┐
              │  User (Entity)   │
              ├──────────────────┤
              │ - username: str  │
              │ - password: str  │
              │ - id: str        │
              └──────────────────┘
                     △
                     │ uses
        ┌────────────┴──────────────┐
        │                           │
    ┌───┴──────────────┐    ┌──────┴────────────┐
    │  LoginUseCase    │    │ AuthRepository    │
    ├──────────────────┤    │   (Abstract)      │
    │ - authRepository │    ├───────────────────┤
    ├──────────────────┤    │ + login()         │
    │ + call()         │    └───────────────────┘
    └──────────────────┘


┌─────────────────────────────────────────────────────────────┐
│                    DATA LAYER                               │
└─────────────────────────────────────────────────────────────┘

        ┌──────────────────────────┐
        │ AuthRepositoryImpl        │
        │ implements AuthRepository │
        ├──────────────────────────┤
        │ - localDataSource        │
        ├──────────────────────────┤
        │ + login(): Future<User>  │
        └────────────┬─────────────┘
                     │ uses
        ┌────────────▼──────────────┐
        │ LocalAuthDataSource       │
        ├───────────────────────────┤
        │ + verifyCredentials()     │
        │ + getUser()               │
        └────────────┬──────────────┘
                     │ uses
        ┌────────────▼──────────────┐
        │ PasswordUtils             │
        ├───────────────────────────┤
        │ + hashPassword()          │
        │ + verifyPassword()        │
        └───────────────────────────┘

        ┌──────────────────────┐
        │ UserModel            │
        │ (JSON Serializable)  │
        ├──────────────────────┤
        │ - username: String   │
        │ - id: String         │
        ├──────────────────────┤
        │ + toJson()           │
        │ + fromJson()         │
        └──────────────────────┘
```

### Wallet Feature

```
┌──────────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                          │
└──────────────────────────────────────────────────────────────┘

    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │WalletScreen  │  │SendMoneyScreen│ │ CashInScreen │
    └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
           │                 │                  │
           └─────────────────┼──────────────────┘
                             │ uses
                    ┌────────▼──────────┐
                    │  WalletCubit      │
                    ├───────────────────┤
                    │ - walletRepository│
                    │ - tranRepository  │
                    ├───────────────────┤
                    │ + getBalance()    │
                    │ + sendMoney()     │
                    │ + cashIn()        │
                    └────────┬──────────┘
                             │ emits
                    ┌────────▼─────────────────┐
                    │WalletState (Abstract)    │
                    ├──────────────────────────┤
                    │ + WalletInitial          │
                    │ + LoadingBalance         │
                    │ + BalanceLoaded(amount)  │
                    │ + SendingMoney           │
                    │ + SendMoneySuccess()     │
                    │ + CashingIn              │
                    │ + CashInSuccess()        │
                    │ + WalletFailure(msg)     │
                    └──────────────────────────┘


┌──────────────────────────────────────────────────────────────┐
│                   DOMAIN LAYER                               │
└──────────────────────────────────────────────────────────────┘

    ┌──────────────────────────┐
    │  WalletEntity            │
    ├──────────────────────────┤
    │ - userId: String         │
    │ - balance: double        │
    │ - currency: String (₱)   │
    └──────────────────────────┘
                △
                │ uses
    ┌───────────┴────────────┐
    │                        │
┌───┴────────────────┐  ┌────┴──────────────────┐
│GetBalanceUseCase   │  │SendMoneyUseCase       │
├────────────────────┤  ├───────────────────────┤
│ - walletRepository │  │ - walletRepository    │
│ - transRepository  │  │ - transRepository     │
├────────────────────┤  ├───────────────────────┤
│ + call()           │  │ + call(params)        │
└────────────────────┘  └───────────────────────┘
                   │
             ┌─────┴──────────────┐
             │                    │
        ┌────┴──────────────┐ ┌───┴────────────┐
        │ CashInUseCase     │ │WalletRepository│
        ├───────────────────┤ │  (Abstract)    │
        │ - walletRepository│ ├────────────────┤
        │ - transRepository │ │+ getBalance()  │
        ├───────────────────┤ │+ sendMoney()   │
        │ + call(amount)    │ │+ cashIn()      │
        └───────────────────┘ └────────────────┘


┌──────────────────────────────────────────────────────────────┐
│                    DATA LAYER                                │
└──────────────────────────────────────────────────────────────┘

        ┌──────────────────────────┐
        │ WalletRepositoryImpl      │
        │implements WalletRepository
        ├──────────────────────────┤
        │ - localDataSource        │
        ├──────────────────────────┤
        │ + getBalance()           │
        │ + sendMoney()            │
        │ + cashIn()               │
        └────────────┬─────────────┘
                     │ uses
        ┌────────────▼──────────────┐
        │ LocalWalletDataSource     │
        ├───────────────────────────┤
        │ + getBalance()            │
        │ + updateBalance()         │
        │ + sendMoney()             │
        │ + cashIn()                │
        └───────────────────────────┘

        ┌──────────────────────────┐
        │ WalletModel              │
        │(JSON Serializable)       │
        ├──────────────────────────┤
        │ - id: String             │
        │ - userId: String         │
        │ - balance: double        │
        │ - currency: String       │
        ├──────────────────────────┤
        │ + toJson()               │
        │ + fromJson()             │
        └──────────────────────────┘
```

### Transaction Feature

```
┌──────────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                          │
└──────────────────────────────────────────────────────────────┘

            ┌──────────────────┐
            │TransactionsScreen│
            └─────────┬────────┘
                      │ uses
            ┌─────────▼──────────┐
            │ TransactionCubit   │
            ├────────────────────┤
            │- transRepository   │
            ├────────────────────┤
            │+ loadTransactions()│
            │+ refreshTransactions
            └─────────┬──────────┘
                      │ emits
            ┌─────────▼──────────────────┐
            │ TransactionState           │
            ├───────────────────────────┤
            │ + TransactionInitial       │
            │ + TransactionLoading       │
            │ + TransactionLoaded(list)  │
            │ + TransactionFailure(msg)  │
            └───────────────────────────┘


┌──────────────────────────────────────────────────────────────┐
│                   DOMAIN LAYER                               │
└──────────────────────────────────────────────────────────────┘

    ┌─────────────────────────┐
    │ TransactionEntity       │
    ├─────────────────────────┤
    │ - id: String            │
    │ - type: String (send/  │
    │          cashin)        │
    │ - amount: double        │
    │ - recipient: String     │
    │ - timestamp: DateTime   │
    │ - status: String        │
    └─────────────────────────┘
                △
                │ uses
    ┌───────────┴──────────────┐
    │                          │
┌───┴──────────────────┐  ┌────┴────────────────┐
│GetTransactionsUseCase│  │RecordSendMoneyUC    │
├──────────────────────┤  ├─────────────────────┤
│ - transRepository    │  │ - transRepository   │
├──────────────────────┤  ├─────────────────────┤
│ + call()             │  │ + call(params)      │
└──────────────────────┘  └─────────────────────┘
                   │
             ┌─────┴──────────────┐
             │                    │
        ┌────┴──────────────┐ ┌───┴──────────────┐
        │RecordCashInUC     │ │TransactionRepo   │
        ├───────────────────┤ │  (Abstract)      │
        │ - transRepository │ ├──────────────────┤
        ├───────────────────┤ │+ getTransactions │
        │ + call(params)    │ │+ recordCashIn()  │
        └───────────────────┘ │+ recordSendMoney│
                               └──────────────────┘


┌──────────────────────────────────────────────────────────────┐
│                    DATA LAYER                                │
└──────────────────────────────────────────────────────────────┘

        ┌───────────────────────┐
        │ TransactionRepositoryI│
        │mpl implements         │
        │ TransactionRepository │
        ├───────────────────────┤
        │ - remoteDataSource    │
        ├───────────────────────┤
        │ + getTransactions()   │
        │ + recordCashIn()      │
        │ + recordSendMoney()   │
        └─────────┬─────────────┘
                  │ uses
        ┌─────────▼───────────────┐
        │RemoteTransactionDS      │
        ├─────────────────────────┤
        │ - httpClient            │
        │ - baseUrl: String       │
        ├─────────────────────────┤
        │ + getTransactions()     │
        │ + recordCashIn()        │
        │ + recordSendMoney()     │
        └─────────────────────────┘

        ┌──────────────────────────┐
        │ TransactionModel         │
        │ (JSON Serializable)      │
        ├──────────────────────────┤
        │ - id: String             │
        │ - type: String           │
        │ - amount: double         │
        │ - recipient: String      │
        │ - timestamp: String      │
        │ - status: String         │
        ├──────────────────────────┤
        │ + toJson()               │
        │ + fromJson()             │
        │ + toEntity()             │
        └──────────────────────────┘
```

---

## Sequence Diagrams

### User Login Flow

```
User          LoginScreen      AuthCubit       LoginUseCase    AuthRepository   LocalDataSource   PasswordUtils
 │                  │               │                │              │                 │                 │
 │─ Tap Login ─────>│               │                │              │                 │                 │
 │                  │               │                │              │                 │                 │
 │                  │─ login() ───> │                │              │                 │                 │
 │                  │               │                │              │                 │                 │
 │                  │               │─ call() ─────> │              │                 │                 │
 │                  │               │                │              │                 │                 │
 │                  │               │                │─ call() ───> │                 │                 │
 │                  │               │                │              │                 │                 │
 │                  │               │                │              │─ getUser() ────>│                 │
 │                  │               │                │              │<─ User Data ───│                 │
 │                  │               │                │              │                 │                 │
 │                  │               │                │              │─ verifyPassword()─────────────> │
 │                  │               │                │              │                 │                 │
 │                  │               │                │              │                 │<─ bool ───────│
 │                  │               │                │              │<─ true ────────│                 │
 │                  │               │                │<─ User ──────│                 │                 │
 │                  │               │<─ User ────────│              │                 │                 │
 │                  │<─ AuthSuccess ─ User │          │              │                 │                 │
 │                  │               │                │              │                 │                 │
 │<─ Navigate to ───│               │                │              │                 │                 │
 │  Wallet Screen   │               │                │              │                 │                 │
```

### Send Money Flow

```
User      SendMoneyScreen    WalletCubit    SendMoneyUC    WalletRepository   RecordSendMoneyUC  LocalWalletDS  TransactionDS
 │              │                │               │              │                    │                 │                │
 │─ Enter ────> │                │               │              │                    │                 │                │
 │  Details     │                │               │              │                    │                 │                │
 │              │                │               │              │                    │                 │                │
 │─ Tap Send ──>│                │               │              │                    │                 │                │
 │              │                │               │              │                    │                 │                │
 │              │─ sendMoney() ->│               │              │                    │                 │                │
 │              │                │               │              │                    │                 │                │
 │              │ Emit: Sending  │               │              │                    │                 │                │
 │<─ Show ──────│                │               │              │                    │                 │                │
 │  Loading     │                │               │              │                    │                 │                │
 │              │                │─ call() ─────>│              │                    │                 │                │
 │              │                │               │              │                    │                 │                │
 │              │                │               │─ sendMoney()->              │                    │                 │
 │              │                │               │              │                    │                 │                │
 │              │                │               │              │─ deductBalance() →─>                 │                │
 │              │                │               │              │                    │                 │                │
 │              │                │               │              │<─ success ────────│                 │                │
 │              │                │               │              │                    │                 │                │
 │              │                │               │              │────────────────────────────────────>│
 │              │                │               │              │                    │  recordSend()  │
 │              │                │               │              │                    │                 │                │
 │              │                │               │              │                    │─────────────────────────────────>│
 │              │                │               │              │                    │                 │                │
 │              │                │               │              │                    │<─────────────────────────────────│
 │              │                │               │              │                    │ Transaction ID                    │
 │              │                │               │              │<──────────────────│                 │                │
 │              │                │<─ Unit ───────│              │                    │                 │                │
 │              │<─ Success ──────│               │              │                    │                 │                │
 │              │                │               │              │                    │                 │                │
 │<─ Show ──────│                │               │              │                    │                 │                │
 │  Success     │                │               │              │                    │                 │                │
 │  Dialog      │                │               │              │                    │                 │                │
```

### Cash In Flow

```
User      CashInScreen    WalletCubit     CashInUseCase     WalletRepository    RecordCashInUC    LocalWalletDS   TransactionDS
 │            │                │               │                   │                  │                 │               │
 │─ Enter ───>│                │               │                   │                  │                 │               │
 │  Amount    │                │               │                   │                  │                 │               │
 │            │                │               │                   │                  │                 │               │
 │─ Tap Cash ─>               │               │                   │                  │                 │               │
 │  In       │                │               │                   │                  │                 │               │
 │            │                │               │                   │                  │                 │               │
 │            │─ cashIn() ───->│               │                   │                  │                 │               │
 │            │                │               │                   │                  │                 │               │
 │            │ Emit: Cashing  │               │                   │                  │                 │               │
 │<─ Show ────│  In             │               │                   │                  │                 │               │
 │  Loading   │                │               │                   │                  │                 │               │
 │            │                │─ call() ─────>│                   │                  │                 │               │
 │            │                │               │                   │                  │                 │               │
 │            │                │               │─ call() ────────>│                  │                 │               │
 │            │                │               │                   │                  │                 │               │
 │            │                │               │                   │─ addBalance() ──>│                 │               │
 │            │                │               │                   │                  │                 │               │
 │            │                │               │                   │<─ success ──────│                 │               │
 │            │                │               │                   │                  │                 │               │
 │            │                │               │                   │──────────────────────────────────>│
 │            │                │               │                   │                  │  recordCashIn()│
 │            │                │               │                   │                  │                 │               │
 │            │                │               │                   │                  │─────────────────────────────────>│
 │            │                │               │                   │                  │                 │               │
 │            │                │               │                   │                  │<─────────────────────────────────│
 │            │                │               │                   │                  │ Transaction ID                    │
 │            │                │               │<──────── success ──│                  │                 │               │
 │            │                │<─ success ────│                   │                  │                 │               │
 │            │<─ CashInSuccess─│               │                   │                  │                 │               │
 │            │                │               │                   │                  │                 │               │
 │<─ Show ────│                │               │                   │                  │                 │               │
 │  Success   │                │               │                   │                  │                 │               │
 │  Dialog    │                │               │                   │                  │                 │               │
```

### Load Transactions Flow

```
User        TransactionsScreen   TransactionCubit   GetTransactionsUC   TransactionRepository   RemoteDataSource    MockAPI Server
 │               │                     │                  │                     │                      │                    │
 │─ Navigate ──>│                     │                  │                     │                      │                    │
 │  to Screen   │                     │                  │                     │                      │                    │
 │               │                     │                  │                     │                      │                    │
 │               │─ loadTransactions()->                │                     │                      │                    │
 │               │                     │                  │                     │                      │                    │
 │               │ Emit: Loading       │                  │                     │                      │                    │
 │<─ Show ───────│                     │                  │                     │                      │                    │
 │  Loading      │                     │                  │                     │                      │                    │
 │  Indicator    │                     │─ call() ────────>                     │                      │                    │
 │               │                     │                  │                     │                      │                    │
 │               │                     │                  │─ getTransactions() →                       │                    │
 │               │                     │                  │                     │                      │                    │
 │               │                     │                  │                     │─ GET /api/v1/trans →│                    │
 │               │                     │                  │                     │                      │───────────────────>│
 │               │                     │                  │                     │                      │                    │
 │               │                     │                  │                     │                      │<─ JSON Response ───│
 │               │                     │                  │                     │<─ List<TransModel>──│                    │
 │               │                     │                  │<─ List<Entity> ─────│                      │                    │
 │               │<─ List<Entity> ─────│                  │                     │                      │                    │
 │               │                     │                  │                     │                      │                    │
 │               │ Emit: Loaded        │                  │                     │                      │                    │
 │<─ Display ────│ (sorted, formatted) │                  │                     │                      │                    │
 │  Transactions │                     │                  │                     │                      │                    │
 │  List         │                     │                  │                     │                      │                    │
```

---

## Data Flow Diagram

### Complete Application Data Flow

```
                        ┌─────────────┐
                        │   User App  │
                        └──────┬──────┘
                               │
                    ┌──────────┼──────────┐
                    │          │          │
              ┌─────▼─┐  ┌─────▼─┐  ┌────▼────┐
              │ Login │  │ Wallet│  │Transact.│
              │Screen │  │Screen │  │ Screen  │
              └─────┬─┘  └─────┬─┘  └────┬────┘
                    │          │          │
         ┌──────────┴──────────┼──────────┘
         │                     │
    ┌────▼────────────────────▼──────────────┐
    │         State Management Layer         │
    │      (AuthCubit, WalletCubit,          │
    │      TransactionCubit)                 │
    └────┬────────────────────┬──────────────┘
         │                    │
    ┌────▼────┐    ┌──────────▼──────────┐
    │  Use    │    │  Use Cases:         │
    │ Cases   │    │  - LoginUC          │
    │  ────── │    │  - GetBalanceUC     │
    │ - Auth  │    │  - SendMoneyUC      │
    │ - Wallet│    │  - CashInUC         │
    │ - Trans │    │  - GetTransactionsUC│
    └────┬────┘    └──────────┬──────────┘
         │                    │
    ┌────▼────────────────────▼──────────────┐
    │      Repository Interfaces             │
    │  (AuthRepository, WalletRepository,    │
    │   TransactionRepository)               │
    └────┬────────────────────┬──────────────┘
         │                    │
    ┌────▼──────┐    ┌────────▼────────┐
    │  Local     │    │  Remote         │
    │  Data      │    │  Data           │
    │  Sources   │    │  Sources        │
    │  ────────  │    │  ──────────     │
    │ - Auth DS  │    │ - Transaction   │
    │ - Wallet DS│    │   DS (HTTP)     │
    └────┬──────┘    └────────┬────────┘
         │                    │
    ┌────▼──────┐    ┌────────▼────────┐
    │  Local    │    │  Remote API     │
    │  Storage  │    │  (MockAPI)      │
    └───────────┘    └─────────────────┘
```

---

## Component Interaction Summary

| Feature | Presentation → Domain | Domain → Data |
|---------|----------------------|---------------|
| **Auth** | LoginScreen → AuthCubit → LoginUseCase | LoginUseCase → AuthRepository → LocalAuthDataSource |
| **Wallet** | WalletScreen → WalletCubit → GetBalanceUseCase<br/>SendMoneyScreen → WalletCubit → SendMoneyUseCase<br/>CashInScreen → WalletCubit → CashInUseCase | Get/Send/CashIn → WalletRepository → LocalWalletDataSource |
| **Transaction** | TransactionsScreen → TransactionCubit → GetTransactionsUseCase | GetTransactionsUseCase → TransactionRepository → RemoteTransactionDataSource |

---

## State Management Flow

### Cubit State Hierarchy

Each Cubit manages its feature's state with a clear separation of concerns:

```
AuthCubit                   WalletCubit                TransactionCubit
├─ AuthInitial            ├─ WalletInitial           ├─ TransactionInitial
├─ AuthLoading            ├─ LoadingBalance          ├─ TransactionLoading
├─ AuthSuccess(user)      ├─ BalanceLoaded(amount)   ├─ TransactionLoaded(list)
└─ AuthFailure(message)   ├─ SendingMoney            └─ TransactionFailure(msg)
                          ├─ SendMoneySuccess()
                          ├─ CashingIn
                          ├─ CashInSuccess()
                          └─ WalletFailure(message)
```

---

## Error Handling Strategy

```
Try-Catch Flow:
┌─────────────────────────────────────┐
│  Presentation Layer (Screen)        │
│  - Catches UI errors                │
│  - Shows SnackBar with message      │
└──────────┬──────────────────────────┘
           │
┌──────────▼──────────────────────────┐
│  Cubit Layer                        │
│  - Catches all exceptions           │
│  - Emits *Failure state             │
│  - Logs errors                      │
└──────────┬──────────────────────────┘
           │
┌──────────▼──────────────────────────┐
│  Use Case / Repository              │
│  - Throws custom exceptions         │
│  - Validates data                   │
└──────────┬──────────────────────────┘
           │
┌──────────▼──────────────────────────┐
│  Data Source Layer                  │
│  - Network/Storage errors           │
│  - Caught by upper layers           │
└─────────────────────────────────────┘
```

---

## Dependency Injection

All dependencies are injected in `main.dart`:

```dart
// Service Locator Setup
final getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(...));
  getIt.registerSingleton<WalletRepository>(WalletRepositoryImpl(...));
  getIt.registerSingleton<TransactionRepository>(TransactionRepositoryImpl(...));

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt()));
  getIt.registerSingleton<SendMoneyUseCase>(SendMoneyUseCase(getIt()));
  // ... more use cases

  // Cubits
  getIt.registerSingleton<AuthCubit>(AuthCubit(getIt()));
  getIt.registerSingleton<WalletCubit>(WalletCubit(getIt(), getIt()));
  // ... more cubits
}
```

---

## Testing Architecture

```
Unit Tests (Domain & Data Layer)
├─ Use Case Tests
│  └─ Mock Repository
├─ Repository Tests
│  └─ Mock Data Sources
└─ Model Tests (JSON serialization)

Widget Tests (Presentation Layer)
├─ Screen Tests
│  └─ Mock Cubits
├─ Widget Tests
│  └─ Mock Dependencies
└─ BLoC Tests (bloc_test)
   └─ Mock Repositories
```

---

## Summary

The Maya E-Wallet application uses **Clean Architecture** with:

- **Presentation Layer**: Screens, Widgets, Cubits
- **Domain Layer**: Entities, Use Cases, Repository Interfaces
- **Data Layer**: Repository Implementations, Data Sources, Models

This design provides:
- ✅ Clear separation of concerns
- ✅ High testability
- ✅ Easy feature scalability
- ✅ Dependency inversion principle
- ✅ Code reusability
- ✅ Maintainability
