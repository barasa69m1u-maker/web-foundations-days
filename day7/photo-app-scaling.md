# SnapShare: System Scaling & Architecture Plan

## 1. Assumptions & Daily Active Users (DAU)
* **Total Registered Users:** 10,000,000
* **Activity Rate:** 10% of registered users are active daily.
* **Daily Active Users (DAU):** 10,000,000 × 0.10 = **1,000,000 active users/day**
* **User Behavior:** Each active user uploads 1 photo per day and views 50 feed pages per day.
* **File Metrics:** Average original photo size is 2 MB; thumbnail size is 50 KB.
* **Traffic Multiplier:** Peak traffic multiplier is set to **5×** the average load.

---

## 2. Traffic & Storage Calculations

### A. Uploads Per Second (Writes)
* **Total Daily Uploads:** 1,000,000 users × 1 photo = 1,000,000 uploads/day.
* **Seconds in a Day:** 86,400 seconds.
* **Average Write Rate:** 1,000,000 / 86,400 ≈ **11.57 uploads/sec** (~12 writes/sec).
* **Peak Write Rate:** 11.57 × 5 = **57.85 uploads/sec** (~58 writes/sec).

### B. Feed Views Per Second (Reads)
* **Total Daily Feed Views:** 1,000,000 users × 50 feed views = 50,000,000 views/day.
* **Average Read Rate:** 50,000,000 / 86,400 ≈ **578.70 feed views/sec** (~579 reads/sec).
* **Peak Read Rate:** 578.70 × 5 = **2,893.50 feed views/sec** (~2,894 reads/sec).

### C. Photo Storage Per Year
* **Original Photos Storage/Day:** 1,000,000 photos × 2 MB = 2,000,000 MB/day = 2,000 GB/day (~2 TB/day).
* **Thumbnails Storage/Day:** 1,000,000 thumbnails × 50 KB = 50,000,000 KB/day = 50,000 MB/day (~50 GB/day).
* **Total Combined Storage/Day:** 2 TB + 0.05 TB = 2.05 TB/day.
* **Total Storage Per Year:** 2.05 TB/day × 365 days = **748.25 TB/year** (~750 TB/year).

---

## 3. Read-Heavy vs. Write-Heavy Analysis
SnapShare is heavily **read-heavy**. With roughly 579 reads per second (peaking near 2,900 reads/sec) compared to just 12 writes per second (peaking near 58 writes/sec), users spend the vast majority of their time viewing content rather than creating it. 

### Design Implications:
* **Database Scaling:** We must optimize for read operations by utilizing read replicas so that read queries do not block write transactions.
* **Caching Layer:** Heavy caching (using Redis or Memcached) is required for user feeds and metadata to prevent database bottlenecks.
* **Content Delivery:** Media files must be served through a Content Delivery Network (CDN) to offload bandwidth from application servers.

---

## 4. Why Photos Do Not Belong in the Database
Storing binary image data (blobs) directly inside a relational database is a poor practice because:
1. **Performance Degradation:** Databases are optimized for structured tabular data, indexing, and fast queries; storing multi-megabyte files bloats table sizes and severely harms query performance.
2. **Backup Inefficiencies:** Large database backups take longer, become resource-heavy, and are difficult to restore quickly.
3. **Cost and Scalability:** Relational database storage is expensive and difficult to scale horizontally compared to object stores.

### Alternative Storage Solution:
Raw photo files and thumbnails must be stored in a distributed **Object Storage** service (such as Amazon S3), while the database only stores lightweight string references (URLs/file paths) pointing to those assets.

---

## 5. Architecture Diagram

```text
 [Client (Mobile/Web)]
         │
         ▼
     [  DNS  ]
         │
         ▼
  [ Load Balancer ] ──────────────┐
         │                        │
         ▼                        ▼
  [ App Servers ]          [     CDN     ]
   ┌─────┴─────┐                 │
   │           │                 ▼
[ Cache ]   [ Queue ] ──> [ Object Storage ]
 (Redis)     (Worker)     (S3: Photos/Thumbs)
   │
   ▼
[ Primary DB ] <── (Replication) ── [ Read Replica ]
