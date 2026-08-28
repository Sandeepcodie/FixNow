# FixNow — Simple GitHub Workflow

## 1. Basic Rule

FixNow ek shared GitHub project hai.

Har member ko apni assigned branch mein kaam karna hai.

Customer member:

feature/customer-module

Worker member:

feature/worker-module

IMPORTANT:

main branch par direct coding mat karna.

main ko project lead handle karega.

---

# 2. Repository Clone Karna

GitHub repository:

https://github.com/Sandeepcodie/FixNow_project.git

Terminal / PowerShell kholo.

Run:

git clone https://github.com/Sandeepcodie/FixNow_project.git

Phir:

cd FixNow_project

---

# 3. Apni Branch Checkout Karna

## Customer Member

Run:

git checkout feature/customer-module

## Worker Member

Run:

git checkout feature/worker-module

---

# 4. Check Karo Ki Sahi Branch Par Ho

Run:

git branch

Example:

Customer:

* feature/customer-module
  main

Worker:

* feature/worker-module
  main

`*` jis branch ke saamne hai, wahi current branch hai.

Coding start karne se pehle ye check zaroor karo.

---

# 5. IntelliJ Mein Project Open Karo

Ab cloned FixNow folder ko IntelliJ IDEA mein open karo.

Project load hone ke baad:

1. Maven dependencies load hone do.
2. Application run karo.
3. Check karo ki existing project successfully start ho raha hai.

Agar project start nahi hota:

STOP.

Error ka screenshot project lead ko bhejo.

---

# 6. Coding Start Karo

Ab apne assigned module par kaam karo.

Customer:

feature/customer-module

Worker:

feature/worker-module

Sirf assigned task par kaam karo.

Existing Identity aur Service modules ko unnecessarily modify
mat karo.

---

# 7. Kaam Ke Beech Mein Changes Check Karna

Kabhi bhi check karna ho ki kya change hua hai:

git status

Ye batayega ki kaunse files change hui hain.

---

# 8. Kaam Complete Hone Ke Baad

Pehle application run karo.

Phir apne APIs ko Postman se test karo.

Required cases test karo:

- Successful request
- Invalid request
- Not Found
- Conflict / Duplicate where applicable

Database-related operation hai toh SSMS mein bhi verify karo.

---

# 9. Apne Changes Check Karo

Run:

git status

Dekho ki sirf tumhare assigned task ki files changed hain.

Agar koi unexpected/unrelated file dikhe:

STOP.

Project lead ko batao.

---

# 10. Changes Git Mein Add Karna

Jab sab kuch test ho jaye:

git add .

Phir:

git status

dobara run karo.

Check karo ki correct files staged hain.

---

# 11. Commit Karna

Customer example:

git commit -m "completed customer module"

Worker example:

git commit -m "completed worker module"

Commit message simple aur meaningful rakho.

---

# 12. GitHub Par Push Karna

## Customer Member

git push origin feature/customer-module

## Worker Member

git push origin feature/worker-module

Push ke baad tumhara code GitHub ki apni branch mein chala jayega.

---

# 13. GitHub Par Check Karo

GitHub repository open karo.

Apni branch select karo.

Check karo ki:

- tumhari files hain
- tumhara latest commit hai
- code properly uploaded hai

---

# 14. Pull Request Banana

GitHub par:

Your Branch
    ↓
Compare & pull request
    ↓
Pull Request
    ↓
main

Pull Request ka purpose hai:

"Maine apna kaam complete kiya hai. Please review it and merge
it into main."

---

# 15. IMPORTANT — Pull Request Khud Merge Mat Karna

Pull Request create karne ke baad:

WAIT FOR PROJECT LEAD REVIEW.

Project lead code check karega.

Agar sab correct hai:

Project lead → Merge

---

# 16. Agar Changes Maange Jaaye

Agar project lead bole:

"Is code mein change karo."

Toh same branch par kaam continue karo.

Example:

feature/customer-module

Changes karo.

Test karo.

Then:

git add .

git commit -m "fix: review changes"

git push origin feature/customer-module

Existing Pull Request automatically update ho jayega.

Naya Pull Request banane ki zarurat nahi hai.

---

# 17. Agar Git Error Aaye

Agar koi unexpected Git error aaye:

DO NOT randomly commands try karo.

Example errors:

- merge conflict
- branch error
- push rejected
- authentication error
- pull error

STOP.

Error ka screenshot project lead ko bhejo.

---

# 18. Agar Latest Code Chahiye

Agar project lead bole ki latest code lena hai:

Apni branch par ho:

git checkout <your-branch>

Then:

git pull

Example:

Customer:

git checkout feature/customer-module
git pull

Worker:

git checkout feature/worker-module
git pull

Agar conflict aaye:

STOP and ask the project lead.

---

# 19. Important Security Rule

GitHub par kabhi commit mat karo:

- Database password
- API key
- JWT secret
- Payment secret
- Access token
- Personal credentials

Agar accidentally secret commit ho gaya:

STOP and immediately inform the project lead.

---

# 20. Do Not Modify Main

NEVER use main as your working branch.

Wrong:

git checkout main
coding
git add .
git commit

Correct:

Customer:

git checkout feature/customer-module

Worker:

git checkout feature/worker-module

Then coding.

---

# 21. Simple Daily Workflow

Start:

git checkout <your-branch>

Work:

Coding
↓
Run application
↓
Postman testing
↓
Database testing if required

Finish:

git status
↓
git add .
↓
git status
↓
git commit -m "message"
↓
git push origin <your-branch>
↓
Pull Request
↓
Project Lead Review
↓
Merge

---

# 22. Commands You Actually Need

## Clone

git clone <repository-url>

## Enter project

cd FixNow_project

## Change branch

git checkout <branch-name>

## Check branch

git branch

## Check changes

git status

## Add changes

git add .

## Commit

git commit -m "message"

## Push

git push origin <branch-name>

## Get latest branch code

git pull

---

# 23. Simple Meaning

### git clone

GitHub se project apne computer par download karta hai.

### git checkout

Dusri branch par switch karta hai.

### git status

Batata hai ki project mein kya changes hue hain.

### git add .

Changes ko commit ke liye prepare karta hai.

### git commit

Changes ka local checkpoint banata hai.

### git push

Local commits ko GitHub par upload karta hai.

### git pull

GitHub se latest changes lekar aata hai.

### Pull Request

Apne branch ke changes ko main mein merge karne ke
liye review request hai.

---

# 24. Final Workflow

Remember this:

GitHub Repository
       ↓
Clone
       ↓
Your Branch
       ↓
Coding
       ↓
Test
       ↓
git status
       ↓
git add .
       ↓
git commit
       ↓
git push
       ↓
Pull Request
       ↓
Project Lead Review
       ↓
Merge into main

---

# 25. Golden Rules

1. Always work on your assigned branch.

2. Do not directly work on main.

3. Test your code before creating a Pull Request.

4. Check git status before committing.

5. Do not commit passwords or secrets.

6. Do not modify unrelated modules.

7. If a Git conflict/error appears and you don't understand it,
   STOP and ask the project lead.

8. Do not merge your Pull Request yourself.

9. Keep your code inside your assigned module.

10. If something is unclear, ask before changing the architecture.
