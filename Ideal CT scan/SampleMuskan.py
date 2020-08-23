from yade import pack, plot, export

print(" ")
print("-----------------------------------------")
print("-           images for Muskan           -")
print("-----------------------------------------")
print(" ")

# Everything in m, N, Pa, s and kg

# Material
E1 = 8e8 
poisson1 = 0.3 
density1 = 2650

# Other Constants
g =-9.806 #Gravitational acceleration
numDamping = 0.6
numParticles = 100

# Material is created
O.materials.append((FrictMat(young=E1,poisson=poisson1,density=density1)))
mat1 = O.materials[0]


# Geometries (facets on 6 sides, two vectors correspond to center and extent)
O.bodies.append(utils.geom.facetBox((0.2,0.2,1),(0.2,0.2,1),wallMask=63))


# Particle cloud
sp1 = pack.SpherePack()
sp1.makeCloud((0,0,0),(0.4,0.4,2),rMean=.05,rRelFuzz=0,num=numParticles)
sp1.toSimulation()
for b in O.bodies:
    b.mat = mat1

# Engines
O.engines=[
    ForceResetter(),
    InsertionSortCollider([Bo1_Sphere_Aabb(),Bo1_Facet_Aabb(),Bo1_Wall_Aabb()]),
    InteractionLoop(
	[Ig2_Sphere_Sphere_L3Geom(),Ig2_Facet_Sphere_L3Geom(),Ig2_Wall_Sphere_L3Geom()],
	[Ip2_FrictMat_FrictMat_FrictPhys()],
	[Law2_L3Geom_FrictPhys_ElPerfPl()]
    ),
    GravityEngine(gravity=(0,0,g), label='gravity'),
    NewtonIntegrator(damping=numDamping,label='newton'),
    PyRunner(command="yade.export.text('SphereDB.txt')",realPeriod=30) # call the print function after 30 s 
]


# Time step
O.dt=.5*utils.PWaveTimeStep()

# Run the simulation
O.run()


