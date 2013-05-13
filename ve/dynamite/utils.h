#include "bh.h"
#ifndef __BH_VE_DYNAMITE_UTILS_H
#define __BH_VE_DYNAMITE_UTILS_H

size_t read_file(const char* filename, char** contents);
void assign_string(char*& output, const char* input);
const char* type_text(bh_type type);

const char* opcode_to_opstr(bh_opcode opc);
const char* bhtype_to_shorthand(bh_type type);

#endif

