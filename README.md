Inlämning 2: Avancerad Hantering av Liten Bokhandel
Skapad av: Moamin Al-khazraji, YH25

Denna inlämning bygger vidare på den tidigare databasdesignen för "Liten Bokhandel". Fokus ligger på att implementera avancerad logik, säkerställa dataintegritet genom transaktioner och automatisera flöden med hjälp av triggers.
Utökad funktionalitet och moment
I denna del av projektet har följande tekniska moment implementerats och testats:

Datahantering och Analys (JOINs & Aggregering)
För att kunna hämta ut meningsfull information ur databasen används avancerade sökningar:
INNER JOIN: Används för att koppla ihop kunder med deras faktiska beställningar.
LEFT JOIN: Säkerställer att även kunder som ännu inte lagt en order (t.ex. nyskapade konton) syns i systemet.
GROUP BY & HAVING: Möjliggör analys av kundbeteende, exempelvis för att identifiera "stammisar" som lagt fler än en beställning.

Dataintegritet och Transaktioner (ACID)
För att skydda databasen mot felaktiga ändringar används transaktioner:
START TRANSACTION & ROLLBACK: Genom att köra ändringar i en transaktion kan vi ångra (rollback) operationer om något går fel, vilket förhindrar att permanent data raderas eller ändras av misstag.

Automatisering med Triggers
Två centrala triggers har skapats för att minska manuellt arbete och öka kontrollen:
Lagersaldo (UpdateLager): Varje gång en ny orderrad registreras minskas antalet böcker automatiskt i tabellen Bocker. Detta garanterar att lagerstatusen alltid är synkad med försäljningen.
Kundlogg (LoggaNyKund): En automatisk loggning sker i tabellen KundLogg varje gång en ny kund registreras, vilket skapar ett historiskt spår av nya medlemmar.

Optimering och Begränsningar (Index & Constraints)
Index (idx_epost): Ett index har skapats på kundernas e-postadresser för att snabba upp sökningar i kundregistret.
Check Constraints: Priskontroller har stärkts för att säkerställa att inga produkter kan säljas med ett pris på 0 eller lägre.

Backup och Återställning
Strategier för att säkra datan har dokumenterats:
Backup: Export av hela databasens struktur och innehåll till en .sql-fil.
Restore: Återställning av databasen från backup-filen för att visa på katastrofberedskap.

<img width="456" height="366" alt="MySQLWorkbench_w0lcTKVE8T" src="https://github.com/user-attachments/assets/086242d9-b73d-49d1-9d32-83f2daae2cb4" />


