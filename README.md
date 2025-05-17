# Smart Mobility Database

A university database design project focused on managing services related to smart mobility, including:

- 🚗 Car Sharing
- 🤝 Car Pooling
- 🚕 Ride Sharing

This system models real-world services such as Uber and BlaBlaCar, simulating realistic usage, scalability, and data volume. The design includes full entity-relationship modeling, SQL schema planning, normalization, access plans, and constraint definitions.

---

## 📌 Features

- **User Registration & Roles**
  - Each user can register as proposer, consumer, or both for each service type.
  - Document verification and profile data are required.

- **Vehicle Management**
  - Users can register one or more vehicles, specifying consumption, wear cost, comfort rating, and other features.
  - Ride sharing eligibility is configurable per vehicle.

- **Service Bookings**
  - Supports reservations for car sharing, car pooling (with flexibility levels), and ride sharing with automatic proposer selection.
  - Tracks availability, fuel level, timing, and cost per service.

- **Review System**
  - Peer-to-peer user rating after each completed service.
  - Includes criteria such as punctuality, behavior, reliability, and user satisfaction.

- **Traffic & Road Monitoring**
  - Real-time tracking of vehicle positions.
  - Roads marked in "alert" if vehicles travel at unusually low speeds (traffic estimation).

- **Route & Variation Handling**
  - Booking variations supported for car pooling with automatic cost adjustment.
  - Ride sharing and pooling support spatial queries and path tracking.

---

## 📊 Technologies

- SQL (MySQL)
- E/R modeling and normalization
- Data analytics on expected usage
- Functional and referential constraints

---

## 📂 Project Contents

- `documentazione.pdf` — Full report (in Italian) with schema, logic, and analysis
- `schema_logico.png` — Logical schema diagram (optional if exported)

---

## 🏫 Academic Context

**University of Pisa**  
**Course**: Databases  
**Year**: 2018  
**Authors**: Giovanni Dipace

---

## 📄 License

This is an academic project. Use for educational and portfolio purposes is permitted.
