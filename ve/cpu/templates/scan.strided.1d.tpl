// Scan operation on one-dimensional arrays with strided access.
{
    {{#OPERAND}}{{#ARRAY}}
    {{TYPE}} *a{{NR}}_current = a{{NR}}_first;
    {{/ARRAY}}{{/OPERAND}}

    {{TYPE_AXIS}} axis  = *a{{NR_SINPUT}}_first;

    int64_t nelements = a{{NR_FINPUT}}_shape[axis];
    int mthreads = omp_get_max_threads();
    int64_t nworkers = nelements > mthreads ? mthreads : 1;

    {{TYPE_INPUT}} cvar = ({{TYPE_INPUT}}){{NEUTRAL_ELEMENT}};
    for(int64_t j=0; j<a{{NR_OUTPUT}}_shape[axis]; ++j) {
        {{#OPERATORS}}
        {{OPERATOR}};
        {{/OPERATORS}}

        {{#OPERAND}}{{#ARRAY}}
        a{{NR}}_current += a{{NR}}_stride[axis];
        {{/ARRAY}}{{/OPERAND}}

    }
}
