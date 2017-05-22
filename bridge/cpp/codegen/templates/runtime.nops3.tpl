<!--(for op, opcode, optype, opcount, _typesigs, layouts, _broadcast in data)-->
    <!--(if ["A", "A", "A"] in layouts)-->
    // @!op!@ - @!opcode!@ - @!optype!@ - @!opcount!@ (A,A,A)
    template <typename TO, typename TL, typename TR>
    inline
    void @!op!@ (multi_array<TO>& res, multi_array<TL>& lhs, multi_array<TR>& rhs)
    {
        Runtime::instance().typecheck<@!opcode!@, TO, TL, TR>();
        Runtime::instance().enqueue(@!opcode!@, res, lhs, rhs);
    }
    <!--(end)-->

    <!--(if ["A", "A", "K"] in layouts)-->
    // @!op!@ - @!opcode!@ - @!optype!@ - @!opcount!@ (A,A,K)
    template <typename TO, typename TL, typename TR>
    inline
    void @!op!@ (multi_array<TO>& res, multi_array<TL>& lhs, const TR rhs)
    {
        Runtime::instance().typecheck<@!opcode!@, TO, TL, TR>();
        Runtime::instance().enqueue(@!opcode!@, res, lhs, rhs);
    }
    <!--(end)-->

    <!--(if ["A", "K", "A"] in layouts)-->
    // @!op!@ - @!opcode!@ - @!optype!@ - @!opcount!@ (A,K,A)
    template <typename TO, typename TL, typename TR>
    inline
    void @!op!@ (multi_array<TO>& res, const TL lhs, multi_array<TR>& rhs)
    {
        Runtime::instance().typecheck<@!opcode!@, TO, TL, TR>();
        Runtime::instance().enqueue(@!opcode!@, res, lhs, rhs);
    }
    <!--(end)-->
<!--(end)-->
