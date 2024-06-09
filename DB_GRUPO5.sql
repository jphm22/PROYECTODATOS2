CREATE DATABASE DB_GRUPO05
	-- La base de datos contiene información de las compras de bienes realizadas durante el año 2023

USE DB_GRUPO05

GO

-- Creamos los esquemas que usaremos

CREATE SCHEMA Almacen
GO

CREATE SCHEMA Compras
GO

CREATE SCHEMA RH
GO


CREATE TABLE Compras.Proveedor
	-- Información general del proveedor
(	
	Codigo_Proveedor CHAR(6) PRIMARY KEY, 
	Nombre_Proveedor VARCHAR(100),
	RUC CHAR(10),
	Telefono VARCHAR(15),
	Correo VARCHAR(25)
)


CREATE TABLE Compras.Comprador
	-- Información general del comprador
(	
	Codigo_Comprador CHAR(6) PRIMARY KEY, 
	Nombre_Comprador VARCHAR(50),
	Correo_Comprador VARCHAR(25)
)


CREATE TABLE Compras.Tipo_Pago
	-- Información relacionada al método de pago, es decir, si es a n días después de la entrega, si es por partes, etc.
(	
	Codigo_Pago CHAR(6) PRIMARY KEY, 
	Descripcion_Pago VARCHAR(200)
)


CREATE TABLE RH.Usuario
	-- Información general del ususario
(	
	Codigo_Usuario CHAR(6) PRIMARY KEY, 
	Nombre_Usuario VARCHAR(50),
	Correo_Usuario VARCHAR(25)
)


CREATE TABLE Compras.Moneda
	-- Moneda con la cuál se realiza la OC
(	
	Codigo_Moneda CHAR(3) PRIMARY KEY, 
	Moneda VARCHAR(25)
)


CREATE TABLE Almacen.Materiales
	-- Material solicitado en la OC
(	
	Codigo_Material CHAR(8) PRIMARY KEY, 
	Nombre_Material VARCHAR(150)
)


CREATE TABLE RH.Tipo_Prioridad
	-- El usuario comparte en el requerimiento que tan prioritario es el material, es decir, si puede afectar a la producción, de reposición, etc.
(	
	Codigo_Prioridad VARCHAR(20) PRIMARY KEY,
	Descripcion_Prioridad VARCHAR(25)
)


CREATE TABLE Compras.Unidad_Medida
	-- Información relacionada a la medida con la que se compra el matrial.
(	
	Codigo_UM VARCHAR(5) PRIMARY KEY, 
	Nombre_UM VARCHAR(50),
	Descripcion_UM VARCHAR(150)
)


CREATE TABLE Compras.Orden_Compra
	-- Detalle de la OC, se agrega la fecha de creación y se relaciona con algunas de las tablas creadas anteriormente, no todas, se explicará el motivo más adelante.
(
	Codigo_OC CHAR(10) PRIMARY KEY,
	Fecha_Creacion DATE,
	-- La OC se realiza toda en una fecha, no se puede emitir una OC por partes.
	Codigo_Proveedor CHAR(6),
	Codigo_Comprador CHAR(6),
	Codigo_Pago CHAR(6),
	Codigo_Usuario CHAR(6),
	Codigo_Moneda CHAR(3),

	FOREIGN KEY (Codigo_Proveedor) REFERENCES Compras.Proveedor(Codigo_Proveedor),
	-- La OC siempre se realiza dirigida a un solo proveedor.
	FOREIGN KEY (Codigo_Comprador) REFERENCES Compras.Comprador(Codigo_Comprador),
	-- Un solo comprador puede realizar una OC.
	FOREIGN KEY (Codigo_Pago) REFERENCES Compras.Tipo_Pago(Codigo_Pago),
	-- El pago de la OC se realiza de solo 1 forma, es decir, toda la OC se paga a 30 días luego de haber entregado la OC, o toda la OC se paga a 60 días, una OC no puede pagarse una parte a 30 días y otra a 60 días.
	FOREIGN KEY (Codigo_Usuario) REFERENCES RH.Usuario(Codigo_Usuario),
	-- Un usuario realiza un requerimiento, si bien es cierto un requerimiento puede tener varias OC, la OC se le asigna a un solo usuario.
	FOREIGN KEY (Codigo_Moneda) REFERENCES Compras.Moneda(Codigo_Moneda)
	-- La OC de compra se realiza en moneda única, en soles, dólares o la moneda que se elija, una parte no puede ser paga en soles y la otra en dólares.
)


CREATE TABLE Compras.Detalle_OC
(
	Codigo_Detalle_OC VARCHAR(14) PRIMARY KEY,
	Fecha_Entrega DATE,
	-- Colocamos la fecha de entrega en el detalle porque una parte de la OC puede ser entregada en una fecha y otra parte puede ser entregada en otra fecha, dependiendo de cuando se requiera.
	Codigo_OC CHAR(10),
	Codigo_Material CHAR(8),
	Codigo_Prioridad VARCHAR(20),
	Codigo_UM VARCHAR(5),
	Cantidad INT,
	-- Se coloca cantidad en el detalle porque no siempre se requiere la misma cantidad en cada OC.
	Precio_Unitario DECIMAL(9,2),
	-- Se coloca ep precio unitario aquí debido a que por temas de inflación el precio puede variar entre una OC y otra, si bien es cierto, la variación en la mayoría de casos no es mucha, existe, de no haber variación esta tabla se hubiese relacionado con la tabla Orden_Compra.

	FOREIGN KEY (Codigo_OC) REFERENCES Compras.Orden_Compra(Codigo_OC),
	-- Conectamos la OC con el detalle, ya que una OC puede tener varios Items.
	FOREIGN KEY (Codigo_Material) REFERENCES Almacen.Materiales(Codigo_Material),
	-- Al haber varios Items en una OC´hay varios materiales en una sola OC, por lo que conectamos esta tabla en el detalle, la hubiesemos conectado en la tabla Orden_Compra si cada orden de compra tubiese un solo item, pero, aunque pasa, regularmente hay varios items en una OC.
	FOREIGN KEY (Codigo_Prioridad) REFERENCES RH.Tipo_Prioridad(Codigo_Prioridad),
	-- Al haber varios materiales en una OC, hay casos en los cuales una parte es más prioritaria que otra, esto se puede relacionar también con las fechas de entrega, los prioritarios se entregan antes y los no tan prioritarios se pueden entregar después.
	FOREIGN KEY (Codigo_UM) REFERENCES Compras.Unidad_Medida(Codigo_UM)
	-- Tema similar a los materiales, al haber varios materiales no todos tienen la misma unidad de medida, algunos pueden ser unidades EA, otros paquetes, etc.
)

-- Ingresamos datos tabla Compras.Comprador

INSERT INTO Compras.Comprador(Codigo_Comprador,Nombre_Comprador,Correo_Comprador) VALUES

	('CHALEU','Charlie Leuso','chaleu@lqsa.com'),
	('WENULI','Wendy Ulid','wenuli@lqsa.com'),
	('JOSRAM','Jose Ramirez','josram@lqsa.com'),
	('SYSTEM','Sistema','system@lqsa.com'),
	('PAMATH','Pamela Athamac','pamath@lqsa.com'),
	('MIKOPA','Mike Opas','mikopa@lqsa.com'),
	('PAUPOR','Paulo Portugay','paupor@lqsa.com'),
	('JAVDAM','Javier Damian','javdam@lqsa.com'),
	('JUASAN','Juan Sanchez','juasan@lqsa.com'),
	('EMMFLO','Emma Flores','emmflo@lqsa.com'),
	('INTNGU','Inthavod Nguyen','intngu@lqsa.com'),
	('VICVAS','Victor Vasquez','vicvas@lqsa.com');

GO

SELECT * FROM Compras.Comprador;

-- Ingresamos datos tabla Compras.Tipo_Pago

INSERT INTO Compras.Tipo_Pago(Codigo_Pago,Descripcion_Pago) VALUES

	('PGZ030','Pago a 30 días'),
	('PGZ060','Pago a 60 días'),
	('PGZ007','Pago a 7 días'),
	('PGZ045','Pago a 45 días'),
	('PGZM30','Pago a plazos en tres cuotas iguales, la primera al momento de realizar el pedido y las siguientes dos a 30 días de intervalo.'),
	('PGZP60','Pago neto a 60 días con descuento por pronto pago del 2% si se realiza en los primeros 10 días.'),
	('PGZP00','Pago neto con descuento por pronto pago del 2% si se realiza en los primeros 10 días.');

GO

SELECT * FROM Compras.Tipo_Pago;

-- Ingresamos datos tabla Compras.Moneda

INSERT INTO Compras.Moneda(Codigo_Moneda,Moneda) VALUES

	('USD','Dolares Americanos'),
	('PEN','Sol Peruano');

GO

SELECT * FROM Compras.Moneda;

-- Ingresamos datos tabla Compras.Proveedor

-- Reemplazamos la longitud permitida por la columna Correo VARCHAR(25), ya que hay proveedores que requieren mayor espacio 

ALTER TABLE Compras.Proveedor
ALTER COLUMN Correo VARCHAR(50);

INSERT INTO Compras.Proveedor(Codigo_Proveedor,Nombre_Proveedor,RUC,Telefono,Correo) VALUES

	('545960','InnovateTech Solutions','2032136044','933696615','ventas@innovatetechsolutions.com'),
	('673039','Genesis Dynamics Group','2095347722','974804755','ventas@genesisdynamicsgr.com'),
	('625337','Velocity Innovations Co.','2060291906','948172557','informes@velocityinnovationsco.com'),
	('411814','Synergetic Solutions LLC','2064438961','956270358','ventas@synergeticsolutionsll.com'),
	('354070','IntegraCore Enterprises','2045268650','938951373','contacto@integracoreenterprises.com'),
	('387241','Vortex Solutions Inc.','2040508147','945634615','ventas@vortexsolutionsin.com'),
	('397535','Nexus Innovations Group','2059138797','914240695','ventas@nexusinnovationsgr.com'),
	('348152','Frontier Dynamics Enterprises','2039396177','943683053','contacto@frontierdynamicsen.com'),
	('484507','Visionary Solutions LLC','2073073185','996725480','contacto@visionarysolutionsll.com'),
	('504882','Prime Edge Technologies','2040809091','921007384','ventas@primeedgete.com'),
	('602025','OreScan Solutions','2084441885','968035257','informes@orescansolutions.com'),
	('581866','RockTech Dynamics','2041663778','946211509','ventas@rocktechdynamics.com'),
	('534740','Synergy Innovations Group','2072404348','998168076','contacto@synergyinnovationsgr.com'),
	('362219','Evolutionary Solutions Inc.','2015837952','926988863','informes@evolutionarysolutionsin.com'),
	('359328','MinerTech Solutions','2056080212','993404377','informes@minertechsolutions.com'),
	('530949','OreMaster Industries','2070769159','981629210','contacto@oremasterindustries.com'),
	('691652','DrillTech Services','2067787676','931610473','contacto@drilltechservices.com'),
	('382722','GeoProbe Innovations','2011461798','957669451','informes@geoprobeinnovations.com'),
	('534658','TerraCore Mining Supplies','2063325389','989703165','informes@terracoreminingsu.com'),
	('636351','RockHawk Technologies','2069567473','982367573','contacto@rockhawktechnologies.com'),
	('496053','OreXpert Solutions','2023520292','928782973','ventas@orexpertsolutions.com'),
	('433765','DiamondEdge Equipment','2028111040','927820438','ventas@diamondedgeequipment.com'),
	('565677','TerraDrill Mining Tools','2018066433','955646606','ventas@terradrillminingto.com'),
	('475851','ApexMiner Resources','2078226270','932402144','ventas@apexminerresources.com'),
	('455093','GeoProspect Technologies','2059201428','974674307','contacto@geoprospecttechnologies.com'),
	('579616','EarthWorks Mining Services','2060136217','945152116','contacto@earthworksminingse.com'),
	('443018','DrillPro Machinery','2037304285','922734827','ventas@drillpromachinery.com'),
	('446313','CoreForge Industries','2072369592','910096241','informes@coreforgeindustries.com'),
	('315730','MineCraft Innovations','2044390927','964009392','informes@minecraftinnovations.com'),
	('404138','TerraDrone Solutions','2057971856','914838862','ventas@terradronesolutions.com'),
	('349040','GeoXtract Resources','2093180920','924398501','contacto@geoxtractresources.com'),
	('616870','OreTech Systems','2053284767','961129858','informes@oretechsystems.com'),
	('573989','RockPulse Mining Equipment','2047844536','952411371','ventas@rockpulseminingeq.com'),
	('324842','GeoScan Prospecting','2092979358','997350959','ventas@geoscanprospecting.com'),
	('307067','TerraTrek Mining Solutions','2021091983','917451860','informes@terratrekminingso.com'),
	('322670','OreTech Dynamics','2051014572','950588664','contacto@oretechdynamics.com'),
	('526066','DrillQuest Technologies','2092234505','947139026','contacto@drillquesttechnologies.com'),
	('347048','CoreTech Supplies','2060320858','999025129','informes@coretechsupplies.com'),
	('541441','RockForge Mining Tools','2048544086','998356060','informes@rockforgeminingto.com'),
	('626002','GeoVision Equipment','2052449554','983404983','contacto@geovisionequipment.com'),
	('468346','TerraForce Technologies','2069814176','938350389','ventas@terraforcetechnologies.com'),
	('525468','MineTech Innovations','2041620730','974846953','informes@minetechinnovations.com'),
	('666320','OreLink Solutions','2027811948','977904966','ventas@orelinksolutions.com'),
	('656207','DrillMax Machinery','2053503472','943157279','contacto@drillmaxmachinery.com'),
	('607695','NextLevel Dynamics Inc.','2030414145','977362365','informes@nextleveldynamicsin.com'),
	('565570','FusionTech Enterprises','2061609507','992975717','informes@fusiontechenterprises.com'),
	('352574','Vertex Innovations Group','2095210965','993227337','contacto@vertexinnovationsgr.com'),
	('348963','Momentum Solutions Inc.','2056831593','987810688','contacto@momentumsolutionsin.com'),
	('705099','BrightPath Ventures','2088995310','978385119','ventas@brightpathventures.com'),
	('706950','Proxima Innovations Co.','2042115010','930385617','ventas@proximainnovationsco.com'),
	('661261','EnvisionTech Dynamics','2051963286','934742132','contacto@envisiontechdynamics.com'),
	('646480','Impact Innovations Group','2096947324','960146543','ventas@impactinnovationsgr.com'),
	('627096','Genesis Ventures Inc.','2058743431','958782564','ventas@genesisventuresin.com'),
	('520857','InnovateNow Corporation','2087302972','946527307','ventas@innovatenowcorporation.com'),
	('689112','FutureForward Enterprises','2061272562','975467969','ventas@futureforwardenterprises.com'),
	('574254','PathFinder Innovations','2046280780','929170024','contacto@pathfinderinnovations.com'),
	('342008','QuantumScape Solutions','2087872325','975030818','informes@quantumscapesolutions.com'),
	('598269','InnovateHub Group','2073998949','947256620','informes@innovatehubgroup.com'),
	('329881','Apex Innovations Co.','2094870806','936059915','contacto@apexinnovationsco.com'),
	('561171','Catalyst Dynamics Inc.','2028477904','967037699','ventas@catalystdynamicsin.com'),
	('618730','Synergy Solutions Group','2096642069','959133062','informes@synergysolutionsgr.com'),
	('543132','Evolutionary Innovations','2028551387','974330068','contacto@evolutionaryinnovations.com'),
	('565358','BlueSky Enterprises','2059118052','952635294','contacto@blueskyenterprises.com'),
	('360480','Quantum Dynamics Inc.','2045803065','937341415','ventas@quantumdynamicsin.com'),
	('506352','Stellar Innovations Group','2049522728','943363678','contacto@stellarinnovationsgr.com'),
	('589409','Peak Performance Partners','2068979428','944381199','informes@peakperformancepa.com'),
	('375322','FusionWorks Corporation','2035767437','929382420','contacto@fusionworkscorporation.com'),
	('506289','Nexus Global Ventures','2024056289','977057152','ventas@nexusglobalve.com'),
	('653019','AlphaOmega Innovations','2055965458','931104097','informes@alphaomegainnovations.com'),
	('458927','TerraNova Industries','2046639416','945207164','ventas@terranovaindustries.com'),
	('483767','BrightFuture Enterprises','2070330395','931439906','ventas@brightfutureenterprises.com'),
	('420709','Horizon Innovations Co.','2044717199','999150892','contacto@horizoninnovationsco.com'),
	('403406','GlobalTech Dynamics','2063415204','947655657','informes@globaltechdynamics.com'),
	('321691','Quantum Leap Solutions','2071204154','956022293','contacto@quantumleapso.com'),
	('538347','Skyline Ventures Inc.','2095435556','991619236','contacto@skylineventuresin.com'),
	('679030','Optimal Outcomes Group','2076566255','940619090','contacto@optimaloutcomesgr.com'),
	('562872','Swift Solutions Corporation','2059855790','922489067','informes@swiftsolutionsco.com'),
	('351622','Pinnacle Innovations Co.','2077665731','970641941','informes@pinnacleinnovationsco.com'),
	('519043','InnovateX Industries','2010606222','955820179','ventas@innovatexindustries.com'),
	('573341','NextGen Dynamics Inc.','2086746132','974841843','ventas@nextgendynamicsin.com'),
	('670964','TechVision Partners','2062428503','924283561','informes@techvisionpartners.com'),
	('315454','FutureWave Enterprises','2061534476','973031099','informes@futurewaveenterprises.com'),
	('362001','Zenith Innovations Group','2061194552','942870693','informes@zenithinnovationsgr.com'),
	('394121','Intellisys Solutions Inc.','2075172861','955195888','contacto@intellisyssolutionsin.com'),
	('390416','InnovatePro Corporation','2087140327','925232688','ventas@innovateprocorporation.com'),
	('638688','Catalyst Ventures LLC','2017765978','948445585','informes@catalystventuresll.com'),
	('367703','Spark Solutions Group','2056527779','932176196','informes@sparksolutionsgr.com'),
	('700542','NovaTech Innovations','2095534366','940444143','informes@novatechinnovations.com'),
	('609945','Prodigy Dynamics Inc.','2022690379','967060493','contacto@prodigydynamicsin.com'),
	('443070','InnovationForge Enterprises','2040269331','982219233','informes@innovationforgeenterprises.com'),
	('605138','Precision Innovations Co.','2065460401','923155166','contacto@precisioninnovationsco.com'),
	('316338','Summit Strategies LLC','2033918889','928289130','contacto@summitstrategiesll.com'),
	('376540','Quantum Edge Solutions','2050140107','946802051','ventas@quantumedgeso.com'),
	('448802','ForwardFocus Enterprises','2097867599','941024298','contacto@forwardfocusenterprises.com'),
	('688658','Insight Innovations Group','2094866345','932750496','informes@insightinnovationsgr.com'),
	('424647','EvolveTech Dynamics','2062458669','972451452','ventas@evolvetechdynamics.com'),
	('348270','VisionQuest Ventures','2069551449','994413572','contacto@visionquestventures.com'),
	('662547','QuantumSphere Solutions','2073821015','997955133','ventas@quantumspheresolutions.com'),
	('477739','Innovate360 Corporation','2035150642','991773624','ventas@innovateventas60corporation.com'),
	('396679','Strategic Innovations Co.','2074799290','922916118','ventas@strategicinnovationsco.com'),
	('579068','NexusTech Innovations','2030816939','911960481','informes@nexustechinnovations.com'),
	('522357','BlueHorizon Enterprises','2069170007','964609655','informes@bluehorizonenterprises.com'),
	('356488','QuantumCore Dynamics','2073772780','931258523','ventas@quantumcoredynamics.com'),
	('623276','StellarTech Solutions','2022528687','940383621','ventas@stellartechsolutions.com'),
	('617288','SynergyPeak Partners','2085213442','915467565','ventas@synergypeakpartners.com'),
	('511305','CoreVision Mining Services','2035376744','917956298','ventas@corevisionminingse.com'),
	('694613','GeoForge Innovations','2098737376','963175646','contacto@geoforgeinnovations.com'),
	('460230','TerraCraft Mining Tools','2010075780','932780859','informes@terracraftminingto.com'),
	('557943','VisionaryTech Co.','2048778793','923926572','contacto@visionarytechco..com'),
	('457566','TerraPulse Prospecting','2089896333','915965126','informes@terrapulseprospecting.com'),
	('396043','DrillLink Technologies','2078380854','999478284','contacto@drilllinktechnologies.com'),
	('613218','GeoEdge Equipment','2085800180','922156673','contacto@geoedgeequipment.com'),
	('386369','InnovateXcel Enterprises','2026884864','935337854','ventas@innovatexcelenterprises.com'),
	('345573','AlphaWave Solutions','2058982053','933511423','ventas@alphawavesolutions.com'),
	('354393','BrightBridge Ventures','2029729148','977748518','ventas@brightbridgeventures.com'),
	('521253','RockMax Mining Solutions','2072626609','932298366','informes@rockmaxminingso.com'),
	('652393','SynergyStream Group','2035651372','963387083','informes@synergystreamgroup.com'),
	('518220','CoreTech Resources','2070670940','950103250','contacto@coretechresources.com'),
	('449578','QuantumPulse Partners','2045675631','959957052','ventas@quantumpulsepartners.com'),
	('628212','OreQuest Technologies','2028063639','976301375','informes@orequesttechnologies.com'),
	('375024','SummitSolutions Co.','2046507745','914264580','ventas@summitsolutionsco..com'),
	('454920','ProdigyTech Ventures','2031087033','984708599','contacto@prodigytechventures.com'),
	('497444','MineForge Dynamics','2042655476','976445484','ventas@mineforgedynamics.com'),
	('621283','InnovateNex Corporation','2093973659','915472749','ventas@innovatenexcorporation.com'),
	('696279','SkylineTech Innovations','2017359762','942169029','ventas@skylinetechinnovations.com'),
	('394152','CatalystCore Enterprises','2092253420','991866758','informes@catalystcoreenterprises.com'),
	('447956','BlueSkyline Group','2018040887','949395455','ventas@blueskylinegroup.com'),
	('473500','GeoQuest Resources','2063981880','990036362','ventas@geoquestresources.com'),
	('614703','CoreVision Prospecting','2013293805','977819138','informes@corevisionprospecting.com'),
	('536073','CanyonCraft Mining Supplies','2069106828','994557963','contacto@canyoncraftminingsu.com'),
	('322197','TerraDrill Solutions','2037046425','935114053','informes@terradrillsolutions.com'),
	('687772','OrePulse Mining Tools','2080279152','910420796','ventas@orepulseminingto.com'),
	('656184','DrillCraft Technologies','2071408161','991535487','informes@drillcrafttechnologies.com'),
	('565068','GeoWorks Supplies','2035053892','962749826','informes@geoworkssupplies.com'),
	('597259','TerraTech Innovations','2065203101','932551830','ventas@terratechinnovations.com'),
	('437450','ProSpectra Mining Solutions','2069017415','985501368','informes@prospectraminingso.com'),
	('430904','GeoTech Drilling Services','2014502051','962719085','ventas@geotechdrillingse.com'),
	('609291','Industria Mecánica Avanzada SRL','2041798011','935877697','informes@industriamecánicaav.com'),
	('669018','OreGenius Technologies','2098476687','978490005','informes@oregeniustechnologies.com'),
	('399818','TerraDrill Exploration','2080437108','989087048','informes@terradrillexploration.com'),
	('517517','RockHive Mining Supplies','2062233434','963160040','contacto@rockhiveminingsu.com'),
	('346847','DrillMaster Innovations','2058443815','944872818','ventas@drillmasterinnovations.com'),
	('523654','DrillTech Innovations','2082607065','952934650','contacto@drilltechinnovations.com'),
	('501134','CoreCraft Mining Tools','2016296424','939687505','ventas@corecraftminingto.com'),
	('529279','TerraProspect Solutions','2053243793','993679728','ventas@terraprospectsolutions.com'),
	('656431','GeoForge Technologies','2012235178','992792413','contacto@geoforgetechnologies.com'),
	('518677','RockPulse Drilling Services','2039455174','944360174','informes@rockpulsedrillingse.com'),
	('656999','OreLink Resources','2065073908','945428264','ventas@orelinkresources.com'),
	('646673','DrillWise Innovations','2093590033','922201517','informes@drillwiseinnovations.com'),
	('400812','GeoSpark Mining Solutions','2076233563','984555778','informes@geosparkminingso.com'),
	('348385','TerraCore Prospecting','2069247007','936556621','contacto@terracoreprospecting.com'),
	('624153','MineMaster Dynamics','2081249178','931399207','contacto@minemasterdynamics.com'),
	('360925','OreXcel Technologies','2023667715','959816031','contacto@orexceltechnologies.com'),
	('584622','CoreCrest Mining Supplies','2034584321','963283610','ventas@corecrestminingsu.com'),
	('563968','RockQuest Drilling Services','2082595495','995143773','contacto@rockquestdrillingse.com'),
	('582203','GeoStrike Innovations','2034809146','960586155','ventas@geostrikeinnovations.com'),
	('401158','TerraMine Resources','2061347393','990701886','ventas@terramineresources.com'),
	('346630','DrillAxis Technologies','2025389280','961029975','contacto@drillaxistechnologies.com'),
	('577536','CorePro Mining Solutions','2013632210','977956094','contacto@coreprominingso.com'),
	('615088','RockPrecision Drilling','2022753276','976249210','ventas@rockprecisiondrilling.com'),
	('581771','GeoTech Mining Tools','2082441948','952487874','ventas@geotechminingto.com'),
	('637767','TerraStrike Dynamics','2090828165','995958031','contacto@terrastrikedynamics.com'),
	('647807','OrePro Solutions','2064103733','958565243','contacto@oreprosolutions.com'),
	('678993','NextLevel Innovations','2030689260','983730723','contacto@nextlevelinnovations.com'),
	('391545','QuantumSpark Solutions','2031765541','946832311','ventas@quantumsparksolutions.com'),
	('356072','ForwardFocus Group','2028005734','956977395','ventas@forwardfocusgroup.com'),
	('479347','PeakPerformance Co.','2050001355','924933717','ventas@peakperformanceco..com'),
	('480867','NexusInnovate Technologies','2039196008','972515808','ventas@nexusinnovatetechnologies.com'),
	('579577','CoreCrafter Mining Supplies','2016725734','961928650','contacto@corecrafterminingsu.com'),
	('636412','Comercializadora Internacional del Sur SAC','2030045654','920019243','contacto@comercializadorainternacionalde.com'),
	('577964','InnovatePrime Group','2088789738','962460175','contacto@innovateprimegroup.com'),
	('519338','PrecisionTech Solutions','2025541758','989729206','informes@precisiontechsolutions.com'),
	('331751','TerraNova Dynamics','2098123998','992044795','informes@terranovadynamics.com'),
	('663397','AlphaInnovate Partners','2090731883','935385105','ventas@alphainnovatepartners.com'),
	('658348','QuantumStream Enterprises','2031428368','946226696','ventas@quantumstreamenterprises.com'),
	('598746','SynergyScape Inc.','2069904554','981270418','contacto@synergyscapeinc..com'),
	('390312','SparkTech Innovations','2085904300','958302279','informes@sparktechinnovations.com'),
	('471538','GenesisGrowth Group','2090004870','929819235','contacto@genesisgrowthgroup.com'),
	('682957','VisionaryVentures Co.','2082627562','990757717','ventas@visionaryventuresco..com'),
	('611071','QuantumForge Technologies','2071173830','988431095','contacto@quantumforgetechnologies.com'),
	('661674','HorizonHub Solutions','2012307006','926354600','informes@horizonhubsolutions.com'),
	('391366','StellarEdge Ventures','2032167460','984152304','informes@stellaredgeventures.com'),
	('499949','EvolutionaryTech Inc.','2036286349','977577539','ventas@evolutionarytechinc..com'),
	('577632','InnovateNexus Group','2076216950','956240880','contacto@innovatenexusgroup.com'),
	('356554','FutureWave Dynamics','2040423524','963404410','ventas@futurewavedynamics.com'),
	('418708','AlphaSphere Ventures','2012576259','915206574','contacto@alphasphereventures.com'),
	('481320','RockForge Drilling Services','2024532277','921208115','informes@rockforgedrillingse.com'),
	('681230','PrecisionPeak Solutions','2069168331','914884511','informes@precisionpeaksolutions.com'),
	('583881','NexusInnovate Group','2053760659','921792777','informes@nexusinnovategroup.com'),
	('542140','BrightFuture Co.','2023295289','986817913','ventas@brightfutureco..com'),
	('626884','QuantumWorks Ventures','2031916780','975201445','contacto@quantumworksventures.com'),
	('654021','GeoMaven Technologies','2035684953','947411688','informes@geomaventechnologies.com'),
	('443140','MountainPeak Mining','2031248691','929386777','ventas@mountainpeakmining.com'),
	('685013','InsightInnovate Solutions','2023653647','912461197','informes@insightinnovatesolutions.com'),
	('619805','HorizonTech Partners','2028914507','962702772','ventas@horizontechpartners.com'),
	('519074','TerraPrecision Prospecting','2076597873','932347525','informes@terraprecisionprospecting.com'),
	('520280','MomentumTech Ventures','2086240177','969958094','informes@momentumtechventures.com'),
	('502760','Innovex Solutions','2087777934','999638084','contacto@innovexsolutions.com'),
	('640191','VertexTech Group','2070667359','946611540','ventas@vertextechgroup.com'),
	('336452','QuantumLeap Innovations','2082058459','971168785','contacto@quantumleapinnovations.com'),
	('333274','CrestWave Enterprises','2040754856','967451022','ventas@crestwaveenterprises.com'),
	('638349','NovaGenix Corporation','2099111179','938603043','informes@novagenixcorporation.com'),
	('525047','InsightEdge Ventures','2056469329','993869802','informes@insightedgeventures.com'),
	('684268','AlphaSynergy Inc.','2041548289','926918781','ventas@alphasynergyinc..com'),
	('497233','EvolveTech Partners','2025670405','937344665','ventas@evolvetechpartners.com'),
	('486606','BlueSky Innovations','2062247009','935064835','contacto@blueskyinnovations.com'),
	('520172','CatalystCore Solutions','2096036258','930542911','informes@catalystcoresolutions.com'),
	('401164','GenesisGrowth Ventures','2023976074','951858692','ventas@genesisgrowthventures.com'),
	('466905','NexusDynamics Co.','2013014894','965396316','ventas@nexusdynamicsco..com'),
	('354183','TerraNova Innovate','2037879673','982032911','ventas@terranovainnovate.com'),
	('662387','PinnaclePeak Dynamics','2093271268','922106407','informes@pinnaclepeakdynamics.com'),
	('477988','ProdigyTech Solutions','2045591633','936351620','informes@prodigytechsolutions.com'),
	('376519','ApexEdge Group','2014599161','934030645','informes@apexedgegroup.com'),
	('640127','BrightBridge Innovations','2026554857','984532025','contacto@brightbridgeinnovations.com'),
	('668244','SynergyStream Inc.','2071460237','916962287','informes@synergystreaminc..com'),
	('537706','FutureQuest Ventures','2027736401','993370977','contacto@futurequestventures.com'),
	('654082','HorizonTech Enterprises','2077073219','991801367','contacto@horizontechenterprises.com'),
	('569225','QuantumForge Group','2083633759','937335384','ventas@quantumforgegroup.com'),
	('445045','MineTech Dynamics','2033185629','910368004','ventas@minetechdynamics.com'),
	('620320','ZenithEdge Dynamics','2097009874','923968607','contacto@zenithedgedynamics.com'),
	('462128','NextGen Ventures','2054297348','919179353','contacto@nextgenventures.com'),
	('378944','MomentumTech Innovations','2028421036','956568144','ventas@momentumtechinnovations.com'),
	('554045','PrecisionWorks Corporation','2025835416','996547555','contacto@precisionworkscorporation.com'),
	('559416','StellarSphere Partners','2020140300','958746050','contacto@stellarspherepartners.com'),
	('591821','InsightInnovate Co.','2057390359','969945759','ventas@insightinnovateco..com'),
	('404932','SummitTech Solutions','2077221273','915007759','ventas@summittechsolutions.com'),
	('345489','AlphaWave Innovations','2062524083','984008527','informes@alphawaveinnovations.com'),
	('641289','OreMagnet Solutions','2010508196','995515753','ventas@oremagnetsolutions.com'),
	('431277','DrillEdge Innovations','2037052999','919397717','ventas@drilledgeinnovations.com'),
	('693420','QuantumPulse Ventures','2029825563','929911925','contacto@quantumpulseventures.com'),
	('462960','NexusTech Solutions','2083504091','979776820','contacto@nexustechsolutions.com'),
	('405814','SynergyPeak Innovations','2085904728','932389793','contacto@synergypeakinnovations.com'),
	('344282','TerraTech Enterprises','2067795273','910405036','informes@terratechenterprises.com'),
	('393069','GenesisGrowth Dynamics','2010106781','969561257','ventas@genesisgrowthdynamics.com'),
	('592499','BlueHorizon Inc.','2076940268','925155571','informes@bluehorizoninc..com'),
	('475677','EvolveEdge Innovations','2052492930','923480254','informes@evolveedgeinnovations.com'),
	('491872','VertexTech Ventures','2079309454','988725059','contacto@vertextechventures.com'),
	('661052','QuantumCore Solutions','2023279848','978170817','informes@quantumcoresolutions.com'),
	('331522','NovaSphere Group','2099521195','913872322','informes@novaspheregroup.com'),
	('461896','CrestWave Dynamics','2021262170','980568989','contacto@crestwavedynamics.com'),
	('492161','InsightEdge Innovations','2022131413','973879079','informes@insightedgeinnovations.com'),
	('387425','AlphaSynergy Ventures','2083989538','943087363','informes@alphasynergyventures.com'),
	('436115','CatalystCore Inc.','2099133646','922915733','contacto@catalystcoreinc..com'),
	('702884','PinnaclePeak Innovate','2026305665','929972420','contacto@pinnaclepeakinnovate.com'),
	('679498','ProdigyTech Partners','2034849591','939462743','contacto@prodigytechpartners.com'),
	('631940','ApexEdge Solutions','2082580190','945738340','informes@apexedgesolutions.com'),
	('450668','BrightBridge Group','2061087746','980743454','informes@brightbridgegroup.com'),
	('360736','SynergyStream Dynamics','2031542234','965116612','contacto@synergystreamdynamics.com'),
	('623865','FutureQuest Innovations','2018711971','992886440','contacto@futurequestinnovations.com'),
	('470059','HorizonTech Ventures','2049482245','976263366','ventas@horizontechventures.com'),
	('662207','QuantumForge Solutions','2046622952','979880457','informes@quantumforgesolutions.com'),
	('592349','SparkInnovate Dynamics','2073150804','984419112','contacto@sparkinnovatedynamics.com'),
	('461892','ZenithEdge Innovations','2083603669','917455788','ventas@zenithedgeinnovations.com'),
	('350031','NextGen Group','2023188425','998585179','contacto@nextgengroup.com'),
	('568072','MomentumTech Enterprises','2082595267','931633231','contacto@momentumtechenterprises.com'),
	('643011','PrecisionWorks Innovate','2098154306','948415916','contacto@precisionworksinnovate.com'),
	('391971','CoreScan Mining Tools','2010546664','927356011','contacto@corescanminingto.com'),
	('315235','InsightInnovate Ventures','2010734303','932273425','contacto@insightinnovateventures.com'),
	('639333','SummitTech Inc.','2036160783','993556873','informes@summittechinc..com'),
	('564756','AlphaWave Dynamics','2050258054','921568264','ventas@alphawavedynamics.com'),
	('395877','InnovateXcel Innovations','2068903166','952972428','ventas@innovatexcelinnovations.com'),
	('373091','Fusion Dynamics Group','2047362267','927543335','ventas@fusiondynamicsgr.com'),
	('678979','QuantumPulse Solutions','2020305154','962483474','informes@quantumpulsesolutions.com'),
	('709129','NexusTech Group','2091436765','917623154','contacto@nexustechgroup.com'),
	('323492','SynergyPeak Ventures','2056613599','937076937','ventas@synergypeakventures.com'),
	('678427','TerraTech Inc.','2068346268','929123387','ventas@terratechinc..com'),
	('479542','GenesisGrowth Innovate','2040587118','996976868','informes@genesisgrowthinnovate.com'),
	('609332','BlueHorizon Ventures','2061905918','926849382','ventas@bluehorizonventures.com'),
	('333562','EvolveEdge Solutions','2082797032','990350994','informes@evolveedgesolutions.com'),
	('584178','VertexTech Dynamics','2051361006','959508744','informes@vertextechdynamics.com'),
	('607468','NovaSphere Innovations','2031458522','913896521','contacto@novasphereinnovations.com'),
	('651912','CrestWave Ventures','2064636255','916512733','informes@crestwaveventures.com'),
	('309547','InsightEdge Solutions','2079854669','973526191','informes@insightedgesolutions.com'),
	('588633','AlphaSynergy Group','2059122549','975703590','informes@alphasynergygroup.com'),
	('612901','CatalystCore Dynamics','2085722448','986132189','contacto@catalystcoredynamics.com'),
	('393657','PinnaclePeak Ventures','2056989030','935910249','informes@pinnaclepeakventures.com'),
	('554891','ProdigyTech Innovations','2041285736','967037886','ventas@prodigytechinnovations.com'),
	('323330','ApexEdge Inc.','2059397245','938760795','informes@apexedgeinc..com'),
	('700756','BrightBridge Innovate','2028110151','971650062','contacto@brightbridgeinnovate.com'),
	('402507','SynergyStream Partners','2052878361','949092822','ventas@synergystreampartners.com'),
	('529631','FutureQuest Dynamics','2018076918','917938780','contacto@futurequestdynamics.com'),
	('555688','HorizonTech Innovations','2095185527','982500847','ventas@horizontechinnovations.com'),
	('460942','QuantumForge Ventures','2052233228','951213038','contacto@quantumforgeventures.com'),
	('343070','SparkInnovate Solutions','2071605458','987437050','contacto@sparkinnovatesolutions.com'),
	('401157','ZenithEdge Group','2043298826','932171863','ventas@zenithedgegroup.com'),
	('443201','NextGen Dynamics','2092944099','922977791','ventas@nextgendynamics.com'),
	('382715','MomentumTech Innovate','2046527651','993639152','informes@momentumtechinnovate.com'),
	('596103','PrecisionWorks Ventures','2027047871','930859506','informes@precisionworksventures.com'),
	('308969','StellarSphere Solutions','2069215736','995353106','contacto@stellarspheresolutions.com'),
	('679142','InsightInnovate Dynamics','2041878961','989444593','informes@insightinnovatedynamics.com'),
	('665441','SummitTech Innovations','2065709768','915183615','ventas@summittechinnovations.com'),
	('635761','AlphaWave Ventures','2072379356','943675733','informes@alphawaveventures.com'),
	('697482','InnovateXcel Group','2040585647','952910641','ventas@innovatexcelgroup.com'),
	('418399','BrightPath Dynamics','2050316824','978950263','ventas@brightpathdynamics.com'),
	('333222','QuantumPulse Innovations','2021161103','979454388','ventas@quantumpulseinnovations.com'),
	('475565','NexusTech Ventures','2064527204','947562214','informes@nexustechventures.com'),
	('421796','SynergyPeak Solutions','2051944470','929902585','ventas@synergypeaksolutions.com'),
	('501658','RockWorks Prospecting','2030623080','972340441','ventas@rockworksprospecting.com'),
	('406842','AgileAxis Enterprises','2020470454','928474966','contacto@agileaxisenterprises.com'),
	('698196','InnovateIQ Corporation','2037634850','929382321','informes@innovateiqcorporation.com'),
	('542795','NexusNest Ventures','2049200468','951703279','contacto@nexusnestventures.com'),
	('605549','QuantumQuartz Inc.','2038002266','993764203','contacto@quantumquartzinc..com'),
	('324377','SynergySphere Dynamics','2066665151','968670098','informes@synergyspheredynamics.com'),
	('582394','MomentumMingle Innovations','2088320389','972053264','informes@momentummingleinnovations.com'),
	('627704','ProdigyPulse Partners','2095114590','925269392','contacto@prodigypulsepartners.com'),
	('658698','AlphaArc Solutions','2011653376','989865532','informes@alphaarcsolutions.com'),
	('446206','ZenithZone Ventures','2040480566','913748780','contacto@zenithzoneventures.com'),
	('650704','EvolveEcho Innovations','2092077813','964905323','informes@evolveechoinnovations.com'),
	('600444','CatalystCrest Group','2052557156','943415754','ventas@catalystcrestgroup.com'),
	('453096','BlueBridge Dynamics','2034777269','957404765','contacto@bluebridgedynamics.com'),
	('457358','NovaNexis Innovate','2067963419','967719961','contacto@novanexisinnovate.com'),
	('572986','CrestCore Enterprises','2073093156','947035745','ventas@crestcoreenterprises.com'),
	('685226','HorizonHive Corporation','2078583856','943236787','contacto@horizonhivecorporation.com'),
	('350112','InsightInfinite Ventures','2085279414','937517018','informes@insightinfiniteventures.com'),
	('619720','PrecisionPulse Solutions','2084770470','931433915','informes@precisionpulsesolutions.com'),
	('671649','SparkSpectrum Inc.','2023148324','910271723','informes@sparkspectruminc..com'),
	('316449','GeoCraft Technologies','2087854618','936732874','ventas@geocrafttechnologies.com'),
	('410349','TerraLink Mining Solutions','2094799108','944773359','contacto@terralinkminingso.com'),
	('404674','GenesisGlide Dynamics','2088238724','926022969','informes@genesisglidedynamics.com'),
	('700549','OreTerra Dynamics','2056231183','986254407','informes@oreterradynamics.com'),
	('432858','DrillMaven Drilling Services','2038169853','998680049','informes@drillmavendrillingse.com'),
	('439900','StellarStream Enterprises','2020432866','991814840','informes@stellarstreamenterprises.com'),
	('660835','FutureFlex Corporation','2039308172','997860084','contacto@futureflexcorporation.com'),
	('330983','SummitSphere Dynamics','2014314434','965566149','informes@summitspheredynamics.com'),
	('476544','QuantumQuest Innovations','2030116800','996220461','informes@quantumquestinnovations.com'),
	('478736','VertexVoyage Partners','2044002035','911955971','contacto@vertexvoyagepartners.com'),
	('362022','SynergySync Solutions','2093490806','910349260','informes@synergysyncsolutions.com'),
	('475454','MomentumMatrix Innovate','2058132801','977736054','ventas@momentummatrixinnovate.com'),
	('420910','ProdigyPeak Group','2010334718','978962176','contacto@prodigypeakgroup.com'),
	('582684','AlphaAstra Ventures','2082224742','940452727','contacto@alphaastraventures.com'),
	('486853','ZenithZone Dynamics','2050536951','917233141','ventas@zenithzonedynamics.com'),
	('401338','InnovateIQ Innovations','2096913890','941789787','contacto@innovateiqinnovations.com'),
	('609948','NexusNest Enterprises','2021372165','994441570','contacto@nexusnestenterprises.com'),
	('617491','QuantumQuartz Corporation','2060297063','943214489','informes@quantumquartzcorporation.com'),
	('514431','SynergySphere Ventures','2031236201','983123376','contacto@synergysphereventures.com'),
	('663292','AgileAxis Solutions','2065425125','942992369','ventas@agileaxissolutions.com'),
	('571589','VentureVista Innovate','2032334433','941426997','contacto@venturevistainnovate.com'),
	('318306','EvolveEcho Group','2014010694','993776435','ventas@evolveechogroup.com'),
	('478552','CatalystCrest Dynamics','2010423898','915851720','contacto@catalystcrestdynamics.com'),
	('330144','NovaNexis Ventures','2021987664','954097990','ventas@novanexisventures.com'),
	('400860','HorizonHive Innovations','2018127008','990450114','contacto@horizonhiveinnovations.com'),
	('540585','InsightInfinite Inc.','2080817347','945172624','ventas@insightinfiniteinc..com'),
	('512168','PrecisionPulse Innovate','2084949959','983289821','informes@precisionpulseinnovate.com'),
	('379432','BlueBridge Partners','2030663277','981390724','ventas@bluebridgepartners.com'),
	('449862','SparkSpectrum Dynamics','2088645285','989629470','ventas@sparkspectrumdynamics.com'),
	('487484','BrightBurst Innovations','2039248982','910227079','informes@brightburstinnovations.com'),
	('361563','TerraTech Ventures','2027063460','917828906','informes@terratechventures.com'),
	('514481','GenesisGlide Corporation','2030680186','981804203','contacto@genesisglidecorporation.com'),
	('458307','PinnaclePeak Solutions','2093363793','994407461','informes@pinnaclepeaksolutions.com'),
	('561203','ApexAegis Innovate','2088071822','939795052','ventas@apexaegisinnovate.com'),
	('340303','StellarStream Group','2050456903','985165746','ventas@stellarstreamgroup.com'),
	('378459','FutureFlex Dynamics','2095393297','939403164','informes@futureflexdynamics.com'),
	('453875','CoreAxis Innovations','2017495975','923500204','ventas@coreaxisinnovations.com'),
	('639502','RockWise Prospecting','2046004197','920395120','informes@rockwiseprospecting.com'),
	('352974','VertexVoyage Solutions','2056482053','988672007','informes@vertexvoyagesolutions.com'),
	('588154','SynergySync Innovate','2092322038','953336581','ventas@synergysyncinnovate.com'),
	('552823','GeoPrecision Mining Tools','2061867697','993355090','informes@geoprecisionminingto.com'),
	('515024','ProdigyPeak Ventures','2086676508','996677082','contacto@prodigypeakventures.com'),
	('579523','AlphaAstra Solutions','2041589154','982187766','informes@alphaastrasolutions.com'),
	('439378','ZenithZone Innovations','2013639828','947770811','informes@zenithzoneinnovations.com'),
	('502391','NexusNest Innovate','2030404604','971893635','ventas@nexusnestinnovate.com'),
	('364654','TerraStrike Technologies','2095498297','953986894','ventas@terrastriketechnologies.com'),
	('330788','SynergySphere Corporation','2054942291','954288303','informes@synergyspherecorporation.com'),
	('628396','AgileAxis Ventures','2087934033','962170104','ventas@agileaxisventures.com'),
	('617330','VentureVista Solutions','2080760072','984907804','ventas@venturevistasolutions.com'),
	('556062','EvolveEcho Enterprises','2051899773','962350493','contacto@evolveechoenterprises.com'),
	('413687','CatalystCrest Innovations','2063653603','928383493','informes@catalystcrestinnovations.com'),
	('433404','NovaNexis Dynamics','2026319289','932949896','ventas@novanexisdynamics.com'),
	('687575','HorizonHive Ventures','2078660737','936825415','informes@horizonhiveventures.com'),
	('477582','ApexAegis Solutions','2040209017','939642898','informes@apexaegissolutions.com'),
	('407168','StellarStream Corporation','2072606036','941794186','informes@stellarstreamcorporation.com'),
	('440629','FutureFlex Ventures','2062496414','991365949','ventas@futureflexventures.com'),
	('607557','SummitSphere Innovations','2059817850','952960543','contacto@summitsphereinnovations.com'),
	('548562','QuantumQuest Solutions','2047025191','992584290','informes@quantumquestsolutions.com'),
	('310301','Spark Spectrum Solutions','2052059243','915512002','contacto@sparkspectrumso.com'),
	('321594','Vertex Ventures Inc.','2083844950','911244847','contacto@vertexventuresin.com'),
	('516551','Prodigy Peak Solutions','2097944550','989587216','contacto@prodigypeakso.com'),
	('422917','Omega Orchid Holdings','2057851378','936075772','ventas@omegaorchidho.com'),
	('562699','StellarWave Innovations','2083464399','990192583','contacto@stellarwaveinnovations.com'),
	('525590','Prism Peak Solutions','2029351167','961890978','contacto@prismpeakso.com'),
	('557689','Velocity Ventures Inc.','2092504521','971290937','ventas@velocityventuresin.com'),
	('441500','Agile Axis Corporation','2099133867','917257418','ventas@agileaxisco.com'),
	('319085','Unity Universe Holdings','2038082353','924575612','informes@unityuniverseho.com'),
	('324567','BrighterBridge Corporation','2019336873','994980360','ventas@brighterbridgecorporation.com'),
	('436993','Insight Impact Holdings','2056895039','982556051','ventas@insightimpactho.com'),
	('576693','QuantumQuest Enterprises','2090316939','960182447','informes@quantumquestenterprises.com'),
	('598796','VistaVision Group','2027609140','916434603','contacto@vistavisiongroup.com'),
	('464266','Catalyst Crest Group','2038695526','937541312','ventas@catalystcrestgr.com'),
	('526403','Vertex Ventures LLC','2030183438','954169141','ventas@vertexventuresll.com'),
	('398935','Catalyst Core Corporation','2082554063','971514285','informes@catalystcoreco.com'),
	('561204','ProdigyPulse Ventures','2068234421','968432045','ventas@prodigypulseventures.com'),
	('523773','Elevate Edge Enterprises','2054060327','981283716','informes@elevateedgeen.com'),
	('591216','Proton Pulse Solutions','2080652217','936272787','contacto@protonpulseso.com'),
	('450185','Dynamo Dynamics LLC','2086202013','938119587','contacto@dynamodynamicsll.com'),
	('475421','InnovateInsight Solutions','2092918639','960121854','ventas@innovateinsightsolutions.com'),
	('336536','Bright Bridge Corporation','2038324306','953014523','contacto@brightbridgeco.com'),
	('444000','PinnaclePeak Corporation','2077188368','924868862','contacto@pinnaclepeakcorporation.com'),
	('703298','GenesisGlobal Ventures','2062287427','998764193','contacto@genesisglobalventures.com'),
	('698052','CrestCore Solutions','2067184246','968122863','ventas@crestcoresolutions.com'),
	('656824','NexusNova Holdings','2020972166','910361630','informes@nexusnovaholdings.com'),
	('326793','AlphaAxis Corporation','2029934185','943229291','contacto@alphaaxiscorporation.com'),
	('310819','MomentumMatrix Group','2064863310','979555222','contacto@momentummatrixgroup.com'),
	('570126','SparkSpectrum Solutions','2069546286','959031868','contacto@sparkspectrumsolutions.com'),
	('571936','SynergySparkle Holdings','2088521099','999027784','contacto@synergysparkleholdings.com'),
	('676075','AlphaApex Enterprises','2097390263','935977289','ventas@alphaapexenterprises.com'),
	('538063','QuantumDynamics Inc.','2077357758','932451580','contacto@quantumdynamicsinc..com'),
	('684881','InsightImpact Holdings','2015325201','991367165','ventas@insightimpactholdings.com'),
	('513947','AgileAxis Corporation','2081320478','925589867','ventas@agileaxiscorporation.com'),
	('565271','Future Flex Solutions','2016665880','979649619','ventas@futureflexso.com'),
	('423884','BlueBridge Innovations','2030298972','968702786','contacto@bluebridgeinnovations.com'),
	('400242','SummitSphere Solutions','2085331275','950367764','ventas@summitspheresolutions.com'),
	('694930','OreForge Drilling Services','2024168944','959675270','ventas@oreforgedrillingse.com'),
	('700466','QuantumQuartz Group','2035908860','985975180','contacto@quantumquartzgroup.com'),
	('648037','VentureVista Ventures','2033872269','956414922','ventas@venturevistaventures.com'),
	('409024','NovaVista Enterprises','2090189589','993890817','ventas@novavistaenterprises.com'),
	('321408','RadiantRidge Holdings','2098387561','929924304','informes@radiantridgeholdings.com'),
	('676415','Pinnacle Pulse Corporation','2092325554','982272414','contacto@pinnaclepulseco.com'),
	('477720','FusionFlex Corporation','2046982629','973699876','ventas@fusionflexcorporation.com'),
	('579366','VelocityVenture Inc.','2096604199','977422263','ventas@velocityventureinc..com'),
	('698753','Alpha Apex Enterprises','2066349000','973725597','ventas@alphaapexen.com'),
	('571724','UnityUniverse Holdings','2070561251','954889672','informes@unityuniverseholdings.com'),
	('409098','ElevateEdge Enterprises','2079801777','937061746','informes@elevateedgeenterprises.com');

GO

SELECT * FROM Compras.Proveedor;

-- Ingresamos datos tabla RH.Usuario

INSERT INTO RH.Usuario(Codigo_Usuario,Nombre_Usuario,Correo_Usuario) VALUES

	('JUACOR','Juanita Cortez','juacor@lqsa.com'),
	('SYSTEM','Sistema','system@lqsa.com'),
	('DANSIL','Daniel Silva','dansil@lqsa.com'),
	('AMANGU','Amanda Nguyen','amangu@lqsa.com'),
	('ALEVAR','Alejandro Vargas','alevar@lqsa.com'),
	('RICMOR','Ricardo Morales','ricmor@lqsa.com'),
	('EMITHO','Emily Thompson','emitho@lqsa.com'),
	('ANALOP','Ana Lopez','analop@lqsa.com'),
	('CARGAR','Carlos Garcia','cargar@lqsa.com'),
	('STECHE','Stephanie Chen','steche@lqsa.com'),
	('FERALV','Fernanda Alvarez','feralv@lqsa.com');

GO

SELECT * FROM RH.Usuario;

-- Ingresamos datos tabla Compras.Unidad_Medida

INSERT INTO Compras.Unidad_Medida(Codigo_UM,Nombre_UM,Descripcion_UM) VALUES

	('EA','Unidad','Se refiere a una unidad individual de un artículo.'),
	('TO','Tonelada','Similar a "TON", representando una unidad de peso.'),
	('PAC','Paquete','Indica un conjunto de artículos o productos empaquetados juntos.'),
	('KG','Kilogramo','Unidad básica de masa en el sistema métrico.'),
	('M','Metro','Unidad básica de longitud en el sistema métrico.'),
	('CM','Centímetro','Una unidad de longitud en el sistema métrico, equivalente a 0.01 metros.'),
	('BT','Botella','Indica una unidad de envasado, comúnmente para líquidos.'),
	('CAN','Lata','Se refiere a una unidad de envase generalmente metálico.'),
	('M2','Metro cuadrado','Una unidad de medida de área en el sistema métrico.'),
	('L','Litro','Una unidad de volumen en el sistema métrico.'),
	('ROL','Rollo','Indica una forma de presentación en forma de cilindro alargado.'),
	('BAG','Bolsa','Indica una unidad de empaque, generalmente para productos a granel.'),
	('CV','Caballo de vapor','Unidad de potencia en el sistema métrico.'),
	('DM','Decímetro','Una unidad de longitud en el sistema métrico, equivalente a 0.1 metros.'),
	('DR','Docena','Representa una cantidad de 12 unidades.'),
	('G','Gramo','Una unidad de masa en el sistema métrico.'),
	('PC','Pieza','Se refiere a una unidad individual de un artículo similar a "EA".'),
	('FT','Pie (Foot)','Es una unidad de longitud en el sistema imperial, equivalente a 0.3048 metros.'),
	('GAL','Galón','Una unidad de volumen en el sistema imperial, equivalente a 4.54609 litros.'),
	('PAA','Paleta','Se refiere a una plataforma utilizada para transportar y apilar mercancías.'),
	('"','Pulgada','Una unidad de longitud en el sistema imperial, equivalente a 2.54 centímetros.'),
	('CAR','Caja','Indica una unidad de empaque que puede contener varios artículos.'),
	('TS','Tarjeta SD','Puede referirse a una tarjeta de memoria tipo SD.'),
	('PAL','Palet','Abreviatura para "paleta", similar a PAA.'),
	('M3','Metro cúbico','Unidad de medida de volumen en el sistema métrico.'),
	('TON','Tonelada','Representa una unidad de peso equivalente a 1,000 kilogramos.'),
	('OZ','Onza','Una unidad de masa en el sistema imperial.');

GO

SELECT * FROM Compras.Unidad_Medida;

-- Ingresamos datos tabla RH.Tipo_Prioridad

ALTER TABLE RH.Tipo_Prioridad
ALTER COLUMN Descripcion_Prioridad VARCHAR(100);

DELETE FROM RH.Tipo_Prioridad;

INSERT INTO RH.Tipo_Prioridad(Codigo_Prioridad,Descripcion_Prioridad) VALUES

	('Routine','Materiales no críticos'),
	('Shutdown','Materiales críticos para continuidad de las operaciones'),
	('Very High','Materiales necesarios de repocisión');

GO

SELECT * FROM RH.Tipo_Prioridad;

-- Ingresamos datos tabla RH.Tipo_Prioridad

SELECT * FROM Almacen.Materiales;

SELECT * FROM Compras.Orden_Compra;

SELECT * FROM Compras.Detalle_OC;

-- Añadimos la columna del total precio a la tabla

ALTER TABLE Compras.Detalle_OC
ADD Total_Price_USD DECIMAL(12, 2);

-- Añadimos los datos multiplicando cantidad por precio, y lo convertimos a una moneda, en este caso USD

UPDATE Compras.Detalle_OC
SET Total_Price_USD = 
    CASE 
        WHEN (SELECT Codigo_Moneda FROM Compras.Orden_Compra WHERE Codigo_OC = Compras.Detalle_OC.Codigo_OC) = 'PEN' 
            THEN (Cantidad * Precio_Unitario) / 3.8
        ELSE Cantidad * Precio_Unitario
    END;

SELECT * FROM Compras.Detalle_OC;

-- Análisis de proveedores en función de la cantidad de líneas de OC emitidas

SELECT TOP 15
    P.Nombre_Proveedor,
    FORMAT(COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0') AS "Cantidad Líneas Compradas",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD), '###,###,###,##0.00')) AS "Valor Comprado",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD) / COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0.00')) AS "Valor Promedio por Línea"
FROM
    Compras.Proveedor P
INNER JOIN
    Compras.Orden_Compra OC ON P.Codigo_Proveedor = OC.Codigo_Proveedor
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY
    P.Nombre_Proveedor
ORDER BY
    COUNT(DOC.Codigo_Detalle_OC) DESC;

-- Como se puede observar en el resultado InnovateTech Solutions es el proveedor con mayor cantidad de líneas emitidas, ya que tiene 12,004 de 37,810; es decir, representa casi la 
-- tercer parte del total de líneas de OCs emitidas, esto supone que es el proveedor con el cual podemos decir que la empresa tiene una relación comercial muy estrecha con este
-- proveedor, esto puede suponerse al amplio catálogo de productos que ofrece, para asegurar este punto analizaremos también que proveedor tiene mayor cantidad de materiales en 
-- su catálogo.

-- Análisis de la diversificación de materiales por proveedor

SELECT TOP 15
    P.Nombre_Proveedor,
    FORMAT(COUNT(DISTINCT DOC.Codigo_Material), '###,###,###,##0') AS Cantidad_Materiales
FROM
    Compras.Proveedor P
INNER JOIN
    Compras.Orden_Compra OC ON P.Codigo_Proveedor = OC.Codigo_Proveedor
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY
    P.Nombre_Proveedor
ORDER BY
    COUNT(DISTINCT DOC.Codigo_Material) DESC;

-- Como podemos ver, la distribución de materiales es bastante similar a la cantidad de líneas de OCs de proveedores, representando InnovateTech Solutions 6,393 materiales de
-- 18,118, esto representa el 35% del total de materiales catalogados; es más, si analizamos ambas tablas presentadas anteriormente, vemos que los 5 primeros proveedores son los
-- mismos, por lo que podemos establecer una relación directa entre la cantidad de materiales que tienen en su catálogo los proveedores y la cantidad de OCs que emite nuestra 
-- empresa.

-- Análisis del valor comprado por proveedor

SELECT TOP 15
    P.Nombre_Proveedor,
    FORMAT(COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0') AS "Cantidad Líneas Compradas",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD), '###,###,###,##0.00')) AS "Valor Comprado",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD) / COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0.00')) AS "Valor Promedio por Línea"
FROM
    Compras.Proveedor P
INNER JOIN
    Compras.Orden_Compra OC ON P.Codigo_Proveedor = OC.Codigo_Proveedor
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY
    P.Nombre_Proveedor
ORDER BY
    SUM(DOC.Total_Price_USD) DESC;

-- Como podemos ver en la tabla resultado hay una amplia diferencia entre el primer y el segundo proveedor con mayor valor comprado, siendo el valor del primero cuatro veces
-- mayor que el segundo, podemos notar que no existe una relación directa entre la cantidad de líneas compradas y el valor comprado. Estamos analizando estos proveedores ya que
-- al tener un valor comprado tan alto también pueden ser considerados proveedores críticos, ya que de no llegar a tiempo sus materiales podrían afectar la continuidad de las
-- operaciones de la mina.

-- Analizamos a los proveedores con mayor valor promedio comprado

SELECT TOP 15
    P.Nombre_Proveedor,
    FORMAT(COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0') AS "Cantidad Líneas Compradas",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD), '###,###,###,##0.00')) AS "Valor Comprado",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD) / COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0.00')) AS "Valor Promedio por Línea"
FROM
    Compras.Proveedor P
INNER JOIN
    Compras.Orden_Compra OC ON P.Codigo_Proveedor = OC.Codigo_Proveedor
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY
    P.Nombre_Proveedor
ORDER BY
    SUM(DOC.Total_Price_USD) / COUNT(DOC.Codigo_Detalle_OC) DESC;

-- Análisis del detalle de la líneas OCs del proveedor PinnaclePeak Solutions

SELECT 
    DOC.Codigo_Detalle_OC,
    CONCAT('$ ', FORMAT(DOC.Precio_Unitario, '###,###,###,##0')) AS "Precio Unitario",
    FORMAT(DOC.Cantidad, '###,###,###,##0') AS "Cantidad",
	CONCAT('$ ', FORMAT(DOC.Total_Price_USD, '###,###,###,##0')) AS "Precio Total",
	M.Nombre_Material AS "Nombre Material",
	DOC.Codigo_UM AS "Unidad Medida"
FROM 
    Compras.Proveedor P
INNER JOIN 
    Compras.Orden_Compra OC ON P.Codigo_Proveedor = OC.Codigo_Proveedor
INNER JOIN 
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
INNER JOIN
    Almacen.Materiales M ON DOC.Codigo_Material = M.Codigo_Material
WHERE 
    P.Nombre_Proveedor = 'PinnaclePeak Solutions'
ORDER BY 
    DOC.Precio_Unitario DESC;

-- Finalmente al analizar el valor promedio por línea podemos notar una gran diferencia entre los primeros proveedores y el tercero, de este resultado podemos determinar que estos
-- 2 primeros proveedores también son clave para la empresa, porque en promedio el valor de sus compras es significativamente alto, como se puede apreciar son varias unidades las compradas
-- pero son más significativos los precios unitarios, aquí podemos identificar oportunidades de negociación tanto en el precio Unitario como en la cantidad, como podemos ver en la última
-- tabla, estos materiales corresponden principalmente a las llantas de los vehículos que transportan la materia extraída de la mina.

-- Creamos la columna Lead Time para analizar los tiempos de entrega

ALTER TABLE Compras.Detalle_OC
ADD Lead_Time INT;

UPDATE Compras.Detalle_OC
SET Lead_Time = DATEDIFF(day, OC.Fecha_Creacion, DOC.Fecha_Entrega)
FROM Compras.Detalle_OC DOC
INNER JOIN Compras.Orden_Compra OC ON DOC.Codigo_OC = OC.Codigo_OC;

SELECT * FROM Compras.Detalle_OC;

-- Análisamos las líneas con lead time menor a 7 días por comprador

SELECT 
    C.Nombre_Comprador,
    COUNT(CASE WHEN DOC.Lead_Time < 7 THEN 1 END) AS "Líneas con Lead Time Menor a 7 Días",
    COUNT(*) AS "Total Lineas Compradas"
INTO 
    Resumen_Líneas_Comprador
FROM 
    Compras.Comprador C
INNER JOIN 
    Compras.Orden_Compra OC ON C.Codigo_Comprador = OC.Codigo_Comprador
INNER JOIN 
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY 
    C.Nombre_Comprador;

SELECT 
    Nombre_Comprador AS "Comprador",
    "Líneas con Lead Time Menor a 7 Días",
    "Total Lineas Compradas",
    CONCAT(CONVERT(DECIMAL(10, 2), CAST( "Líneas con Lead Time Menor a 7 Días" AS DECIMAL) / CAST("Total Lineas Compradas" AS DECIMAL) * 100), '%') AS Porcentaje
FROM 
    Resumen_Líneas_Comprador
ORDER BY 
    Porcentaje DESC;


-- El motivo por el cuál analizamos estas variables es porque regularmente los tiempos de entrega muy cortos como el que estamos analizando tienden a salir con errores en las
-- fechas de entrega, por lo cuál es importante analizarlo para evitar poosible incumplimientos en la emisión de OCs, como podemos ver, porcentualmente la comprador Emma Flores
-- es la que tienen mayor cantidad de líneas con lead time menor a 7 días, pero en términos reales es Charlie Leuso con 2.25%, correspondiente a 443 líneas. Analizado de este
-- modo podemos ver también que este mismo proveedor es el que mayor cantidad de líneas ha comprado, significativamente más que los dempas compradores; pero estamos analizando solo
-- OCs de bienes con materiales catalogados.

-- Análisis de las líneas más compradas que no sean de contrato, esto con la finalidad de evalular posibles nuevos contratos

SELECT TOP 15
    M.Codigo_Material,
    M.Nombre_Material,
    COUNT(CASE WHEN DOC.Precio_Unitario != 0 THEN 1 END) AS "Líneas Sin Contrato",
	FORMAT(SUM(DOC.Cantidad), '###,###,###,##0') AS "Cantidad",
    CONCAT('$', FORMAT(MAX(DOC.Precio_Unitario), '###,###,###,##0.00')) AS "Precio Unitario"
FROM
    Almacen.Materiales M
LEFT JOIN
    Compras.Detalle_OC DOC ON M.Codigo_Material = DOC.Codigo_Material
GROUP BY
    M.Codigo_Material, M.Nombre_Material
ORDER BY
    "Líneas Sin Contrato" DESC;

-- Esta tabla nos permite analizar con que recurrencia se compran los materiales, en específico los que no cuentan con un contrato, como podemos analizar los que más se compran son
-- los lentes, no obstante, dentro de este rango es importante resaltar también los que tienen grandes cantidades, como de los items 11 y 12, ya que al ser tantas las unidades compradas
-- una ligera variación en los precios puede afectar el valor total de la OC. No analizamos por cantidad comprada ya que en algunos casos si bien es cierto las cantidades son muy superiores
-- al no ser items tan solicitados no tendría mucho sentido realizar contratos, ya que la duración de estos y la volatilidad de los precios podría hacer que fijar un precio no sea tan
-- conveniente para el proveedor.

-- Análisis de las líneas de con contrato más usadas

SELECT TOP 15
    M.Codigo_Material,
    M.Nombre_Material,
    COUNT(CASE WHEN DOC.Precio_Unitario = 0 THEN 1 END) AS "Líneas Con Contrato",
    FORMAT(SUM(DOC.Cantidad), '###,###,###,##0') AS "Cantidad"
FROM
    Almacen.Materiales M
LEFT JOIN
    Compras.Detalle_OC DOC ON M.Codigo_Material = DOC.Codigo_Material
GROUP BY
    M.Codigo_Material, M.Nombre_Material
ORDER BY
    "Líneas Con Contrato" DESC;

-- Como podemos analizar las líneas que tienen contrato, aunque son usados no lo son tanto como en el caso de las línea que no lo tienen, al comparar ambas tablas podemos notar que
-- hay varios materiales con los que se podrían realizar contratos que puedan beneficiar a la empresa y al proveedor.

-- Análisis del valor de las líneas por rangos

SELECT
    CASE 
        WHEN Total_Price_USD < 10000 THEN 'Menor a $10K'
        WHEN Total_Price_USD BETWEEN 10000 AND 50000 THEN 'Entre $10K y $50K'
        WHEN Total_Price_USD BETWEEN 50000 AND 100000 THEN 'Entre $50K y $100K'
        WHEN Total_Price_USD BETWEEN 100000 AND 500000 THEN 'Entre $100K y $500K'
        ELSE 'Mayor a $100K'
    END AS Rango_Precio,
    FORMAT(COUNT(*), '###,###,###,##0')  AS "Líneas Compradas"
FROM
    Compras.Detalle_OC
GROUP BY
    CASE 
        WHEN Total_Price_USD < 10000 THEN 'Menor a $10K'
        WHEN Total_Price_USD BETWEEN 10000 AND 50000 THEN 'Entre $10K y $50K'
        WHEN Total_Price_USD BETWEEN 50000 AND 100000 THEN 'Entre $50K y $100K'
        WHEN Total_Price_USD BETWEEN 100000 AND 500000 THEN 'Entre $100K y $500K'
        ELSE 'Mayor a $100K'
    END
ORDER BY
    "Líneas Compradas" DESC;

-- Realizamos este análisis ya que es común que la empresas grandes subcontraten servicios como compras menores ya que les permite ahorrar en sueldos y salarios, además
-- pueden evitar pagar regalías y otros beneficios con los que normalmente cuentan, para esto pueden realizar Órdenes de Servicios para que una tercera empresa realice
-- las compras u otra empresa tenga en su planilla al nuevo personal, en este caso hemos identificado que hay una gran oportunidad en OC de bienes catalogados menores a $10K,
-- por lo cual en el siguiente análisis averiguaremos cual es la cantidad promedio de líneas en este rango por mes.

-- Análisis de las líneas con montos menores a $10K

SELECT
    DATENAME(MONTH, OC.Fecha_Creacion) AS Mes,
    FORMAT(COUNT(CASE WHEN DOC.Total_Price_USD < 10000 THEN 1 END), '###,###,###,##0') AS "Líneas Menores a $10K"
FROM
    Compras.Orden_Compra OC
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY
    DATENAME(MONTH, OC.Fecha_Creacion)
ORDER BY
    "Líneas Menores a $10K" DESC;

-- Como podemos analizar en el cuadro durante el segundo semestre del año es cuando mayor cantidad de líneas de OCs se emiten, esto puede abrir la posibilidad de contratar apoyo
-- durante este periodo manteniendo un personal fijo de la compañía durante todo el año y otros variables principalmente en los últimos meses pero en planilla de un tercero, lo
-- cuál libera a la empresa de ciertas responsabilidades y gastos como ya s ehabía mencionado anteriormente.

-- Analizamos que tipo de pago es el más utilizado por la empresa por OCs

SELECT
    TP.Codigo_Pago,
    TP.Descripcion_Pago,
    COUNT(OC.Codigo_OC) AS "Recuento OCs"
FROM
    Compras.Tipo_Pago TP
LEFT JOIN
    Compras.Orden_Compra OC ON TP.Codigo_Pago = OC.Codigo_Pago
GROUP BY
    TP.Codigo_Pago, TP.Descripcion_Pago
ORDER BY
	"Recuento OCs" DESC;

-- Como podemos analizar, la empresa tiene una posición fuerte de negociación puesto que la gran mayoría de las OCs emitidas son con un plazo de pago a 60 días, esto puede significar
-- también que sus proveedores tienen un posicionamiento fuerte en el mercado, o por lo menos un capital considerable, puesto que para recibir sus pago en un plazo de 60 días es
-- necesario contar con un capital considerable, en el caso de los pagos en los próximos 7 días, es posible que se traten de proveedores locales, puesto que como apoyo para la comunidad
-- normalmente se realizan compras a estos, quienen al no tener mucho capital la empresa para apoyarlos realiza pagos en los próximos días.

-- Analizamos en que mes se emiten más líneas prioritatias Shutdown

SELECT
    DATENAME(MONTH, OC.Fecha_Creacion) AS Mes,
    COUNT(*) AS "Lineas Shutdown"
FROM
    Compras.Orden_Compra OC
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
INNER JOIN
    RH.Tipo_Prioridad TP ON DOC.Codigo_Prioridad = TP.Codigo_Prioridad
WHERE
    TP.Codigo_Prioridad = 'Shutdown'
GROUP BY
    DATENAME(MONTH, OC.Fecha_Creacion)
ORDER BY
    "Lineas Shutdown" DESC;

-- Como se puede observar la empresa no emite muchas líneas para Parada, esto puede significar que en cuanto respecta a los materiales catalogados tienen una buena planificación
-- por lo que es muy poco probable que tenga problemas en este evento, no obstante, se debe tener cuidado a la hora de realizar estas solicitudes, puesto que, aunque sean pocas
-- son muy importantes para la continuidad de las operaciones.

-- Analizamos el Lead Time de cada material

SELECT 
    M.Codigo_Material,
    M.Nombre_Material,
    MAX(DOC.Lead_Time) AS Lead_Time_Días
FROM 
    Almacen.Materiales M
LEFT JOIN 
    Compras.Detalle_OC DOC ON M.Codigo_Material = DOC.Codigo_Material
GROUP BY 
    M.Codigo_Material, M.Nombre_Material
ORDER BY 
    Lead_Time_Días DESC;

-- Este análisis es importante y puede ser de mucha utilidad para los usuarios a la hora de solicitar materiales importantes, ya que al considerar el Lead Time máximo
-- se puede dar una idea de con cuanta antelación se debe hacer un requerimiento, esto es importante, puesto que como vemos en el cuadro hay materiales que se demoran años
-- en estar disponibles, por lo que esta data es muy relevante para el planeamiento de los futuros eventos que tenga que pasar la empresa.

-- Analizamos en que mes se ha gastado más

SELECT
    DATENAME(MONTH, OC.Fecha_Creacion) AS Mes,
    FORMAT(COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0') AS "Cantidad Líneas Compradas",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD), '###,###,###,##0.00')) AS "Valor Comprado",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD) / COUNT(DOC.Codigo_Detalle_OC), '###,###,###,##0.00')) AS "Valor Promedio por Línea"
FROM
    Compras.Orden_Compra OC
INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
GROUP BY
    DATENAME(MONTH, OC.Fecha_Creacion)
ORDER BY
    SUM(DOC.Total_Price_USD) DESC;

-- Como podemos analizar en el cuadro, los meses que más se ha gastado son Enero, Noviembre y Diciembre; si esta es la tendencia en todos los años puede significar que durante estos
-- meses la empresa se abastece, principalmente en enro que también muestra el valor promedio más alto, por lo que los bienes comprados pueden ser repuestos necesarios para la
-- continuidad de las operaciones, por otro lado, podemos darnos una idea de como se desarrollarán los gatos en el siguiente año, por lo que influye en el presupuesto asignado y
-- permite tener una varilla sobre la cual se deben desarrollar la compras en el año siguiente cuidando de no sobrepasar porcentaulmente los mostrados.

-- CANTIDAD DE PRODUCTOS CRITICOS DE PRIORIDAD ROUTINE POR FECHA DE ENTREGA
	--SELECT *
	--FROM (
	SELECT 
		DATENAME(MONTH,C.Fecha_Entrega) AS [FECHA DE ENTREGA],	
		COUNT(*) AS TOTAL ,
		C.Codigo_Prioridad
	
	FROM Compras.Detalle_OC C
	INNER JOIN Compras.Orden_Compra B
	ON C.Codigo_OC=B.Codigo_OC
	GROUP BY  C.Fecha_Entrega,
		C.Codigo_Prioridad
	HAVING C.Codigo_Prioridad = 'Routine'
	--ORDER BY 1 ASC
	--) AS ED


	-----------------------------------------------------------------------------


	--Listar los proveedores que tienen más de # órdenes de compra emitidas en total
	SELECT Compras.Proveedor.Nombre_Proveedor, 
		COUNT(Compras.Orden_Compra.Codigo_OC) AS Num_OC
	FROM Compras.Proveedor
	INNER JOIN Compras.Orden_Compra 
	ON Compras.Proveedor.Codigo_Proveedor = Compras.Orden_Compra.Codigo_Proveedor
	GROUP BY Compras.Proveedor.Nombre_Proveedor
	HAVING COUNT(Compras.Orden_Compra.Codigo_OC) > 100
	ORDER BY COUNT(Compras.Orden_Compra.Codigo_OC) DESC ; 

	--Análisis del consumo de materiales por mes
	SELECT
    FORMAT(OC.Fecha_Creacion, 'MM-yyyy') AS "Mes",
    COUNT(DOC.Codigo_Detalle_OC) AS "Cantidad Líneas Compradas",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD), '###,###,###,##0.00')) 
	AS "Valor Comprado"	
	FROM
    Compras.Orden_Compra OC
	INNER JOIN
    Compras.Detalle_OC DOC ON OC.Codigo_OC = DOC.Codigo_OC
	GROUP BY
    FORMAT(OC.Fecha_Creacion, 'MM-yyyy')
	ORDER BY
    FORMAT(OC.Fecha_Creacion, 'MM-yyyy');


	--Análisis del consumo de materiales por codigo
	SELECT
    M.Codigo_Material,
    COUNT(DOC.Codigo_Detalle_OC) AS "Cantidad Líneas Compradas",
    CONCAT('$ ', FORMAT(SUM(DOC.Total_Price_USD), '###,###,###,##0.00')) AS "Valor Comprado"
	FROM
    Compras.Detalle_OC DOC
	INNER JOIN
    Almacen.Materiales M ON DOC.Codigo_Material = M.Codigo_Material
	GROUP BY
    M.Codigo_Material
	ORDER BY
    COUNT(DOC.Codigo_Detalle_OC) DESC;
















