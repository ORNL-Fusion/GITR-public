#ifndef _IONIZE_
#define _IONIZE_

#ifdef __CUDACC__
#define CUDA_CALLABLE_MEMBER_DEVICE __device__
#define CUDA_CALLABLE_MEMBER_HOST __host__
#else
#define CUDA_CALLABLE_MEMBER_DEVICE
#define CUDA_CALLABLE_MEMBER_HOST
#endif

#include "Particle.h"
#ifdef __CUDACC__
#include <thrust/random.h>
#include <curand_kernel.h>
#endif

#ifdef __GNUC__ 
#include <random>
#include <stdlib.h>
#endif

#include "interpRateCoeff.hpp"

struct ionize { 
    int nR_Dens;
    int nZ_Dens;
    float* DensGridr;
    float* DensGridz;
    float* ne;
    int nR_Temp;
    int nZ_Temp;
    float* TempGridr;
    float* TempGridz;
    float* te;
    int nTemperaturesIonize;
    int nDensitiesIonize;
    float* gridDensity_Ionization;
    float* gridTemperature_Ionization;
    float* rateCoeff_Ionization;
    const float dt;
#if __CUDACC__
    curandState *state;
#else
    std::mt19937 *state;
#endif

        ionize(float _dt,
#if __CUDACC__
                curandState *_state,
#else
                std::mt19937 *_state,
#endif
                int _nR_Dens,int _nZ_Dens,float* _DensGridr,
    float* _DensGridz,float* _ne,int _nR_Temp, int _nZ_Temp,
    float* _TempGridr, float* _TempGridz,float* _te,int _nTemperaturesIonize,
    int _nDensitiesIonize,float* _gridTemperature_Ionization,float* _gridDensity_Ionization,
    float* _rateCoeff_Ionization
              ) : dt(_dt), state(_state), nR_Dens(_nR_Dens), nZ_Dens(_nZ_Dens), DensGridr(_DensGridr), DensGridz(_DensGridz),ne(_ne),
        nR_Temp(_nR_Temp), nZ_Temp(_nZ_Temp), TempGridr(_TempGridr), TempGridz(_TempGridz), te(_te),
   nTemperaturesIonize(_nTemperaturesIonize), nDensitiesIonize(_nDensitiesIonize), gridTemperature_Ionization(_gridTemperature_Ionization), gridDensity_Ionization(_gridDensity_Ionization), rateCoeff_Ionization(_rateCoeff_Ionization) {}
    
        CUDA_CALLABLE_MEMBER_DEVICE 
                void operator()(Particle &p) const { 
	if(p.hitWall == 0.0){        
        //std::cout << "interpolating rate coeff at "<< p.x << " " << p.y << " " << p.z << std::endl;
        float tion = interpRateCoeff2d ( p.charge, p.x, p.y, p.z,nR_Temp,nZ_Temp, TempGridr,TempGridz,te,DensGridr,DensGridz, ne,nTemperaturesIonize,nDensitiesIonize,gridTemperature_Ionization,gridDensity_Ionization,rateCoeff_Ionization );	
    float P1 = 1-exp(-dt/tion);
	
        //std::cout << "calculating r1 " << std::endl;i
#if PARTICLESEEDS > 0
	#ifdef __CUDACC__
	float r1 = curand_uniform(&p.streams[0]);
	#else
	std::uniform_real_distribution<float> dist(0.0, 1.0);
	float r1=dist(p.streams[0]);
	#endif
#else
#if __CUDACC__
    float r1 = curand_uniform(state);
#else
        std::uniform_real_distribution<float> dist(0.0, 1.0);
            float r1=dist(state[0]);
#endif
#endif

	if(r1 <= P1)
	{
		p.charge = p.charge+1;
	} 
	}	

	} 
};

#endif
