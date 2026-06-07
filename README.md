
# RemoteRecruit

RemoteRecruit is a SwiftUI-based iOS application that allows users to browse remote job opportunities, search jobs, and view detailed job information.

---

## Features

- Browse remote jobs
- Search jobs by title, company, or location
- View detailed job information
- Loading state handling
- Empty state handling
- Error state handling
- Local search with debounce
- Unit tested ViewModels

---

## Architecture


### High-Level Flow

```text
SwiftUI View
      ↓
   ViewModel
      ↓
   UseCase
      ↓
 Repository
      ↓
 DataSource
      ↓
    API
```


The project follows MVVM and Clean Architecture principles.

### Presentation Layer

- SwiftUI Views
- ViewModels

### Domain Layer

- Models
- Use Cases
- Protocols

### Data Layer

- Repository
- Remote Data Source
- Local Data Source
- API Client

---

## Tech Stack

- SwiftUI
- MVVM
- Async/Await
- Combine
- Dependency Injection
- XCTest

---

## Data Source

The application uses the Remotive Jobs API:

https://remotive.com/api/remote-jobs

---

## Search Implementation

The API search endpoint was found to return unfiltered results. To provide a better user experience, jobs are loaded once and searched locally using debounced filtering.

This approach provides:

- Faster search experience
- Reduced network calls
- Offline-friendly behavior

---

## Project Structure

```text
RemoteRecruit
│
├── Presentation
│   ├── Views
│   ├── ViewModels
│
├── Domain
│   ├── Models
│   ├── UseCases
│
├── Data
│   ├── Repository
│   ├── RemoteDataSource
│   ├── LocalDataSource
│
├── Networking
│
├── Resources
│
└── Tests
```

---

## Unit Tests

Unit tests are included for:

- JobListViewModel
- JobDetailViewModel

Tests cover:

- Successful job loading
- Empty state
- Error state
- Search functionality
- Data formatting

---

## Assumptions

- Remote jobs are fetched from the Remotive API.
- Search is performed locally after the initial data load.
- Network failures can fall back to cached/local data when available.

---

## Setup Instructions

### Requirements

- Xcode 16+
- iOS 17+
- Swift 6

### Steps

1. Clone the repository
2. Open the project
3. Run the application on Simulator or Device

---

## Future Improvements

- Pagination
- Job bookmarking
- Company logos
- Advanced filtering
- Test coverage expansion

---

## Author

Rashida Dalal
