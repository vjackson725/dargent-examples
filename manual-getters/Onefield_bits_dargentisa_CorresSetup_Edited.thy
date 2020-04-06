(*
This file is generated by Cogent

*)

theory Onefield_bits_dargentisa_CorresSetup_Edited
imports "/home/laf027/cogent/branches/dargentisa/c-refinement/Deep_Embedding_Auto"
"/home/laf027/cogent/branches/dargentisa/c-refinement/Cogent_Corres"
"/home/laf027/cogent/branches/dargentisa/c-refinement/Tidy"
"/home/laf027/cogent/branches/dargentisa/c-refinement/Heap_Relation_Generation"
"/home/laf027/cogent/branches/dargentisa/c-refinement/Type_Relation_Generation"
"build_onefield_bits/Onefield_bits_dargentisa_ACInstall"
"build_onefield_bits/Onefield_bits_dargentisa_TypeProof"
begin

(* C type and value relations *)

instantiation unit_t_C :: cogent_C_val
begin
  definition type_rel_unit_t_C_def: "\<And> r. type_rel r (_ :: unit_t_C itself) \<equiv> r = RUnit"
  definition val_rel_unit_t_C_def: "\<And> uv. val_rel uv (_ :: unit_t_C) \<equiv> uv = UUnit"
  instance ..
end

instantiation bool_t_C :: cogent_C_val
begin
definition type_rel_bool_t_C_def: "\<And> typ. type_rel typ (_ :: bool_t_C itself) \<equiv> (typ = RPrim Bool)"
definition val_rel_bool_t_C_def:
   "\<And> uv x. val_rel uv (x :: bool_t_C) \<equiv> (boolean_C x = 0 \<or> boolean_C x = 1) \<and>
     uv = UPrim (LBool (boolean_C x \<noteq> 0))"
instance ..
end



context update_sem_init begin
lemmas corres_if = corres_if_base[where bool_val' = boolean_C,
                     OF _ _ val_rel_bool_t_C_def[THEN meta_eq_to_obj_eq, THEN iffD1]]
end
(* C heap type class *)
class cogent_C_heap = cogent_C_val +
  fixes is_valid    :: "lifted_globals \<Rightarrow> 'a ptr \<Rightarrow> bool"
  fixes heap        :: "lifted_globals \<Rightarrow> 'a ptr \<Rightarrow> 'a"


(* Non generated stuff *)
named_theorems GetSetDefs
(* was obtained from find_theorems name:get_aa_part0.
The deref prefix means that we don't take a pointer as an argument
contrary to the C code.
 *)
find_theorems name:get_aa
definition deref_d3_get_aa_part0 :: "t1_C \<Rightarrow> 32 word"
  where deref_d3_get_aa_part0_def[GetSetDefs]  :
   "deref_d3_get_aa_part0 b = ((data_C b).[0] >> 1)  &&  0x7FFFFFFF"


definition deref_d4_get_aa_part1 :: "t1_C \<Rightarrow> 32 word"
  where  deref_d4_get_aa_part1_def[GetSetDefs]  :
 "deref_d4_get_aa_part1 b = (data_C b).[1]  && 1"

definition deref_d2_get_aa :: "t1_C \<Rightarrow> 32 word" 
  where deref_d2_get_aa_def[GetSetDefs]  :
  "deref_d2_get_aa b = deref_d3_get_aa_part0 b || 
  (deref_d4_get_aa_part1 b << 31)"

(* no C counterpart (would be the counterpart of
an unboxed record nested in a record layout: then the 
compiler generate this) 
*)
abbreviation t1_C_aa_type 
   where  "t1_C_aa_type \<equiv> RPrim (Num U32)"

definition t1_C_to_uval :: "t1_C \<Rightarrow> (_,_,_) uval" 
 where t1_C_to_uval_def[GetSetSimp]  :
  "t1_C_to_uval b = URecord [(UPrim (LU32 (deref_d2_get_aa b)), t1_C_aa_type )]"

(* Now the setters *)
find_theorems name:set_aa name:def

definition deref_d6_set_aa_part0 :: "t1_C \<Rightarrow> 32 word \<Rightarrow> t1_C"
  where deref_d6_set_aa_part0_def[GetSetDefs] : "deref_d6_set_aa_part0 b v =
    data_C_update (\<lambda>a. Arrays.update a 0
                            (a.[0] && 1 ||  (v && 0x7FFFFFFF << Suc 0))) b"

definition deref_d7_set_aa_part1 :: "t1_C \<Rightarrow> 32 word \<Rightarrow> t1_C"
  where  deref_d7_set_aa_part1_def[GetSetDefs] :
  "deref_d7_set_aa_part1 b v =
    data_C_update (\<lambda>a. Arrays.update a (Suc 0)
                            (a.[Suc 0] && 0xFFFFFFFE ||
                             v && 1)) b"



(* TODO: tell Zilin to remove this redundancy mask (&& 1 and && 0x7FFF..).
Indeed, they are already performed in the parts
 *)
definition deref_d5_set_aa :: "t1_C \<Rightarrow> 32 word \<Rightarrow> t1_C"
   where  deref_d5_set_aa_def[GetSetDefs] : 
  "deref_d5_set_aa b v =
      deref_d7_set_aa_part1 (deref_d6_set_aa_part0 b (v && 0x7FFFFFFF)) 
      ((v >> 31) && 1)"


(* get set *)

lemma get_set_aa[GetSetSimp] : "deref_d2_get_aa (deref_d5_set_aa b v) = v"
  sorry


(* Typeclass instances *)
instantiation t1_C :: cogent_C_val
begin
definition type_rel_t1_C_def[TypeRelSimp]: "\<And> typ. type_rel typ (_ :: t1_C itself) \<equiv> (typ = RRecord [t1_C_aa_type ])"
definition val_rel_t1_C_def[ValRelSimp]:
    " val_rel uv (x :: t1_C) \<equiv> uv = t1_C_to_uval x "
instance ..
end

instantiation t1_C ::  cogent_C_heap
begin
  definition is_valid_t1_C_def[IsValidSimp]:
    " is_valid \<equiv> is_valid_t1_C "
  definition heap_t1_C_def[HeapSimp]:
    "heap = heap_t1_C"
  instance ..
end

(* End of non generated stuff *)

local_setup \<open> local_setup_val_rel_type_rel_put_them_in_buckets "onefield_bits_dargentisa.c" \<close>
local_setup \<open> local_setup_instantiate_cogent_C_heaps_store_them_in_buckets "onefield_bits_dargentisa.c" \<close>
locale Onefield_bits_dargentisa = "onefield_bits_dargentisa" + update_sem_init
begin

(* Relation between program heaps *)
definition
  heap_rel_ptr ::
  "(funtyp, abstyp, ptrtyp) store \<Rightarrow> lifted_globals \<Rightarrow>
   ('a :: cogent_C_heap) ptr \<Rightarrow> bool"
where
  "\<And> \<sigma> h p.
    heap_rel_ptr \<sigma> h p \<equiv>
   (\<forall> uv.
     \<sigma> (ptr_val p) = Some uv \<longrightarrow>
     type_rel (uval_repr uv) TYPE('a) \<longrightarrow>
     is_valid h p \<and> val_rel uv (heap h p))"

lemma heap_rel_ptr_meta:
  "heap_rel_ptr = heap_rel_meta is_valid heap"
  by (simp add: heap_rel_ptr_def[abs_def] heap_rel_meta_def[abs_def])

local_setup \<open> local_setup_heap_rel "onefield_bits_dargentisa.c" \<close>

definition state_rel :: "((funtyp, abstyp, ptrtyp) store \<times> lifted_globals) set"
where
  "state_rel  = {(\<sigma>, h). heap_rel \<sigma> h}"

lemmas val_rel_simps[ValRelSimp] =
  val_rel_word
  val_rel_ptr_def
  val_rel_unit_def
  val_rel_unit_t_C_def
  val_rel_bool_t_C_def
  val_rel_fun_tag

lemmas type_rel_simps[TypeRelSimp] =
  type_rel_word
  type_rel_ptr_def
  type_rel_unit_def
  type_rel_unit_t_C_def
  type_rel_bool_t_C_def

(* Non generated stuff *)

(* Now, we need to generate the lemmas

Adapted from the following code, in the generated CorresSetup
file with typeclass instances for arrays
 *)

ML \<open>mk_lems "onefield_bits_dargentisa.c" @{context} |> 
  List.map (fn l => ( ( ("lemma " ^
(# name l) ^ "[" ^ bucket_to_string (# bucket l) ^ "] :\n\"" ^ ( (# prop l) |>
  (Syntax.string_of_term @{context}) ))
   |> writeln ); writeln "\"\n\n"))
 \<close>



(* Contrary to the generated lemma, v' is of type U32 rather than
array 
also, the original line was
 modify  (heap_t1_C_update (\<lambda>a. a(ptr := data_C_update (\<lambda>a. v') (a ptr))))

should be solved by
apply(tactic \<open>corres_put_boxed_tac @{context} 1\<close>
*)

lemmas facts1 = val_rel_ptr_def gets_to_return return_bind
lemmas facts2 = state_rel_def heap_rel_def val_rel_ptr_def type_rel_ptr_def heap_rel_ptr_meta
lemmas facts3 = facts2 IsValidSimp HeapSimp

lemma corres_put_t1_C_aa_writable[PutBoxed] :
"[] \<turnstile> \<Gamma>' \<leadsto> \<Gamma>x | \<Gamma>e \<Longrightarrow>
\<Gamma>' ! x = Some (TRecord typ (Boxed Writable ptrl)) \<Longrightarrow>
type_rel (type_repr (TRecord typ (Boxed Writable ptrl))) TYPE(t1_C ptr) \<Longrightarrow>
val_rel (\<gamma> ! x) x' \<Longrightarrow>
val_rel (\<gamma> ! v) (v' :: 32 word) \<Longrightarrow>
\<Xi>', [], \<Gamma>' \<turnstile> Put (Var x) 0
               (Var v) : TRecord
                          (typ[0 := (fst (typ ! 0), fst (snd (typ ! 0)),
                                     Present)])
                          (Boxed Writable ptrl) \<Longrightarrow> 

length typ = 1 \<Longrightarrow>
corres state_rel (Put (Var x) 0 (Var v))
 (do ptr <- gets (\<lambda>_. x');
     _ <- guard (\<lambda>s. is_valid_t1_C s ptr);
     _ <-
     modify (heap_t1_C_update (\<lambda>a. a(ptr := deref_d5_set_aa (a ptr) v' )))
      ;
     gets (\<lambda>_. ptr)
  od)
 \<xi>' \<gamma> \<Xi>' \<Gamma>' \<sigma> s "
  by  (tactic \<open>corres_put_boxed_tac @{context} 1\<close>)
(*
This is a decompilation of corres_put_boxed_tac

 apply (simp add:facts1)
  apply(elim exE)
  apply (cut_tac corres_put_boxed)
        apply (simp add:gets_to_return[THEN eq_reflection])
       apply(simp)
      apply(assumption)
     apply(assumption) 
    apply assumption
   apply assumption
  apply (clarsimp simp add:facts3)
  thm HeapSimp
  apply (erule u_t_p_recE)
   apply(clarsimp dest!:type_repr_uval_repr simp add:TypeRelSimp)
  apply(clarsimp dest!:type_repr_uval_repr simp add:TypeRelSimp)

  apply(frule all_heap_rel_ptrD)
    apply assumption  
   apply(clarsimp  simp add:TypeRelSimp)
  apply((frule all_heap_rel_updE, assumption) )  
  prefer 5
      apply (simp add:TypeRelSimp ValRelSimp)
     apply (simp add:TypeRelSimp ValRelSimp GetSetSimp )
    apply (simp add:TypeRelSimp ValRelSimp)
   apply (simp add:TypeRelSimp ValRelSimp )
  apply (simp add:TypeRelSimp ValRelSimp GetSetSimp)
*)
(* 
 type_rel (type_repr (fst (snd (typ ! 0)))) TYPE(32 word[2]) \<Longrightarrow>
*)
lemma corres_take_t1_C_aa_writable[TakeBoxed] :
"\<Gamma>' ! x = Some (TRecord typ (Boxed Writable undefined)) \<Longrightarrow>
 [] \<turnstile> \<Gamma>' \<leadsto> \<Gamma>x | \<Gamma>e \<Longrightarrow>
 val_rel (\<gamma> ! x) x' \<Longrightarrow>
 type_rel (type_repr (TRecord typ (Boxed Writable undefined))) TYPE(t1_C ptr) \<Longrightarrow>
 type_rel (type_repr (fst (snd (typ ! 0)))) TYPE(32 word) \<Longrightarrow>
 \<Xi>', [], \<Gamma>' \<turnstile> Take (Var x) 0 e : te \<Longrightarrow>
 \<Xi>', [], \<Gamma>x \<turnstile> Var x : TRecord typ (Boxed Writable undefined) \<Longrightarrow>
 \<Xi>', [], Some (fst (snd (typ ! 0))) #
          Some (TRecord (typ[0 := (fst (typ ! 0), fst (snd (typ ! 0)), taken)]) (Boxed Writable undefined)) #
          \<Gamma>e \<turnstile> e : te \<Longrightarrow>
 [] \<turnstile> fst (snd (typ ! 0)) :\<kappa> k \<Longrightarrow>
 S \<in> k \<or> taken = Taken \<Longrightarrow>
 (\<And>vf z.
     val_rel vf z \<Longrightarrow>
     corres state_rel e (e' z) \<xi>' (vf # \<gamma> ! x # \<gamma>) \<Xi>'
      (Some (fst (snd (typ ! 0))) #
       Some (TRecord (typ[0 := (fst (typ ! 0), fst (snd (typ ! 0)), taken)]) (Boxed Writable undefined)) # \<Gamma>e)
      \<sigma> s) \<Longrightarrow>
 corres state_rel (Take (Var x) 0 e) (do _ <- guard (\<lambda>s. is_valid_t1_C s x');
                                         gets (\<lambda>s. deref_d2_get_aa (heap_t1_C s x')) >>= e'
                                      od)
  \<xi>' \<gamma> \<Xi>' \<Gamma>' \<sigma> s 
"
  by(tactic \<open>corres_take_boxed_tac @{context} 1\<close>)
(*
 apply(simp add:val_rel_ptr_def)
  apply (elim exE)
  apply (rule corres_take_boxed)
             apply simp
            apply simp
           apply simp
          apply simp
         apply (simp add:facts3)
        apply simp
       apply simp
      apply simp
     apply simp
    apply simp
   apply (simp add:facts3)

   apply (erule u_t_p_recE)
    apply(clarsimp dest!:type_repr_uval_repr simp add:TypeRelSimp)

   apply(clarsimp dest!:type_repr_uval_repr simp add:TypeRelSimp)
   apply(frule all_heap_rel_ptrD)
     apply assumption
    apply (clarsimp simp add:TypeRelSimp ValRelSimp)
   apply (clarsimp simp add:TypeRelSimp ValRelSimp GetSetSimp)
  apply (clarsimp simp add:TypeRelSimp ValRelSimp)
*)
  

lemma corres_member_t1_C_aa_writable[MemberReadOnly] :
"\<Gamma>' ! x = Some (TRecord typ (Boxed ReadOnly ptrl)) \<Longrightarrow>
 val_rel (\<gamma> ! x) x' \<Longrightarrow>
 type_rel (type_repr (TRecord typ (Boxed ReadOnly ptrl))) TYPE(t1_C ptr) \<Longrightarrow>
 type_rel (type_repr (fst (snd (typ ! 0)))) TYPE(32 word) \<Longrightarrow>
 \<Xi>', [], \<Gamma>' \<turnstile> Member (Var x) 0 : te \<Longrightarrow>
 \<Xi>', [], \<Gamma>' \<turnstile> Var x : TRecord typ (Boxed ReadOnly ptrl) \<Longrightarrow>
 corres state_rel (Member (Var x) 0) (do _ <- guard (\<lambda>s. is_valid_t1_C s x');
                                         gets (\<lambda>s. deref_d2_get_aa (heap_t1_C s x'))
                                      od)
  \<xi>' \<gamma> \<Xi>' \<Gamma>' \<sigma> s 
"
  by(tactic \<open>corres_take_boxed_tac @{context} 1\<close>)


lemma corres_let_put_t1_C_aa_writable[LetPutBoxed] :
"[] \<turnstile> \<Gamma>' \<leadsto> \<Gamma>x | \<Gamma>e \<Longrightarrow>
 \<Gamma>' ! x = Some (TRecord typ (Boxed Writable ptrl)) \<Longrightarrow>
 type_rel (type_repr (TRecord typ (Boxed Writable ptrl))) TYPE(t1_C ptr) \<Longrightarrow>
 val_rel (\<gamma> ! x) x' \<Longrightarrow>
 val_rel (\<gamma> ! v) v' \<Longrightarrow>
 \<Xi>', [], \<Gamma>' \<turnstile> expr.Let (Put (Var x) 0 (Var v)) e : ts \<Longrightarrow>
 \<Xi>', [], \<Gamma>x \<turnstile> Put (Var x) 0
                (Var v) : TRecord (typ[0 := (fst (typ ! 0), fst (snd (typ ! 0)), Present)])
                           (Boxed Writable ptrl) \<Longrightarrow>
 length typ = 1 \<Longrightarrow>
 (\<And>\<sigma> s. corres state_rel e (e' x') \<xi>' (\<gamma> ! x # \<gamma>) \<Xi>'
          (Some (TRecord (typ[0 := (fst (typ ! 0), fst (snd (typ ! 0)), Present)]) (Boxed Writable ptrl)) # \<Gamma>e) \<sigma>
          s) \<Longrightarrow>
 corres state_rel (expr.Let (Put (Var x) 0 (Var v)) e)
  (do ptr <- gets (\<lambda>_. x');
      _ <- guard (\<lambda>s. is_valid_t1_C s ptr);
      _ <- modify (heap_t1_C_update (\<lambda>a. a(ptr := deref_d5_set_aa (a ptr) v')));
      gets (\<lambda>_. ptr) >>= e'
   od)
  \<xi>' \<gamma> \<Xi>' \<Gamma>' \<sigma> s 
"
  by (tactic \<open>corres_let_put_boxed_tac @{context} 1\<close>)


(* Now we have all proven the lemmas that mk_lems should generate *)

(* End of non generated stuff *)

(* Generating the specialised take and put lemmas *)

(* Non-generated stuff: supplementary argument: list of ignored types *)
local_setup \<open> local_setup_take_put_member_case_esac_specialised_lemmas "onefield_bits_dargentisa.c"
    ["t1_C"] \<close>
local_setup \<open> fold tidy_C_fun_def' Cogent_functions \<close>

end (* of locale *)


end
