/*
 * Copyright 2012 Troels Blum <troels@blum.dk>
 *
 * This file is part of cphVB <http://code.google.com/p/cphvb/>.
 *
 * cphVB is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * cphVB is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with cphVB. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __KERNALPARAMETER
#define __KERNALPARAMETER

#include <iostream>
#include "OCLtype.h"
#include "ResourceManager.hpp"

class KernelParameter
{
protected:
    virtual void printOn(std::ostream& os) const = 0;
public:
    static KernelParameter* create(cphvb_array* spec, ResourceManager* resourceManager);
    virtual void addToKernel(cl::Kernel& kernel, unsigned int argIndex) const = 0;
    virtual OCLtype type() const = 0;
    friend std::ostream& operator<< (std::ostream& os, KernelParameter const& kp);
};

#endif
