class ReportsController < ApplicationController

  layout "report"

  def user_list
    @users = User.scoped
    @users = @users.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    @users = @users.select("id, registration_number, username, email, phone, alt_phone")
    @users = @users.order("registration_number asc")
  end

  def cat_with_users
    @users = User.scoped
    @users = @users.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    @categories = Category.
      includes(:users, :self_and_ancestors, :self_and_descendants => :users).
      select("categories.name, users.id").
      where('users_categories.id' => @users).sort_by {|c| c.fqn}
    # TODO todavía hay una 1+n aquí...
  end

end

<<-SQL


SELECT "categories"."id" AS t0_r0,
        "categories"."parent_id" AS t0_r1,
        "categories"."created_at" AS t0_r2,
        "categories"."updated_at" AS t0_r3,
        "categories"."organization_id" AS t0_r4,
        "categories"."name_translations" AS t0_r5,
        "categories"."fqn_translations" AS t0_r6,
        "categories"."children_count" AS t0_r7,
        "users"."id" AS t1_r0,
        "users"."username" AS t1_r1,
        "users"."email" AS t1_r2,
        "users"."password_digest" AS t1_r3,
        "users"."date_of_birth" AS t1_r4,
        "users"."identity_document" AS t1_r5,
        "users"."member_code" AS t1_r6,
        "users"."organization_id" AS t1_r7,
        "users"."phone" AS t1_r8,
        "users"."alt_phone" AS t1_r9,
        "users"."address" AS t1_r10,
        "users"."registration_date" AS t1_r11,
        "users"."registration_number" AS t1_r12,
        "users"."admin" AS t1_r13,
        "users"."superadmin" AS t1_r14,
        "users"."created_at" AS t1_r15,
        "users"."updated_at" AS t1_r16,
        "users"."deleted_at" AS t1_r17,
        "self_and_ancestors_categories"."id" AS t2_r0,
        "self_and_ancestors_categories"."parent_id" AS t2_r1,
        "self_and_ancestors_categories"."created_at" AS t2_r2,
        "self_and_ancestors_categories"."updated_at" AS t2_r3,
        "self_and_ancestors_categories"."organization_id" AS t2_r4,
        "self_and_ancestors_categories"."name_translations" AS t2_r5,
        "self_and_ancestors_categories"."fqn_translations" AS t2_r6,
        "self_and_ancestors_categories"."children_count" AS t2_r7,
        "self_and_descendants_categories"."id" AS t3_r0,
        "self_and_descendants_categories"."parent_id" AS t3_r1,
        "self_and_descendants_categories"."created_at" AS t3_r2,
        "self_and_descendants_categories"."updated_at" AS t3_r3,
        "self_and_descendants_categories"."organization_id" AS t3_r4,
        "self_and_descendants_categories"."name_translations" AS t3_r5,
        "self_and_descendants_categories"."fqn_translations" AS t3_r6,
        "self_and_descendants_categories"."children_count" AS t3_r7,
        "users_categories"."id" AS t4_r0,
        "users_categories"."username" AS t4_r1,
        "users_categories"."email" AS t4_r2,
        "users_categories"."password_digest" AS t4_r3,
        "users_categories"."date_of_birth" AS t4_r4,
        "users_categories"."identity_document" AS t4_r5,
        "users_categories"."member_code" AS t4_r6,
        "users_categories"."organization_id" AS t4_r7,
        "users_categories"."phone" AS t4_r8,
        "users_categories"."alt_phone" AS t4_r9,
        "users_categories"."address" AS t4_r10,
        "users_categories"."registration_date" AS t4_r11,
        "users_categories"."registration_number" AS t4_r12,
        "users_categories"."admin" AS t4_r13,
        "users_categories"."superadmin" AS t4_r14,
        "users_categories"."created_at" AS t4_r15,
        "users_categories"."updated_at" AS t4_r16,
        "users_categories"."deleted_at" AS t4_r17 
FROM "categories"
LEFT OUTER JOIN "categories_users" ON "categories_users"."category_id" = "categories"."id"
LEFT OUTER JOIN "users" ON "users"."id" = "categories_users"."user_id"
LEFT OUTER JOIN "category_hierarchies" ON "category_hierarchies"."descendant_id" = "categories"."id"
LEFT OUTER JOIN "categories" "self_and_ancestors_categories" ON "self_and_ancestors_categories"."id" = "category_hierarchies"."ancestor_id"
LEFT OUTER JOIN "category_hierarchies" "descendant_hierarchies_categories_join" ON "descendant_hierarchies_categories_join"."ancestor_id" = "categories"."id"
LEFT OUTER JOIN "categories" "self_and_descendants_categories" ON "self_and_descendants_categories"."id" = "descendant_hierarchies_categories_join"."descendant_id"
LEFT OUTER JOIN "categories_users" "users_categories_join" ON "users_categories_join"."category_id" = "self_and_descendants_categories"."id"
LEFT OUTER JOIN "users" "users_categories" ON "users_categories"."id" = "users_categories_join"."user_id"

WHERE "users"."id" IN (SELECT "users"."id" FROM "users" WHERE "users"."deleted_at" IS NULL)

SQL


    # id integer NOT NULL,
    # username character varying(255) NOT NULL,
    # email character varying(255) NOT NULL,
    # password_digest character varying(255),
    # date_of_birth date,
    # identity_document character varying(255),
    # member_code character varying(255),
    # organization_id integer,
    # phone character varying(255),
    # alt_phone character varying(255),
    # address text,
    # registration_date date,
    # registration_number integer,
    # admin boolean,
    # superadmin boolean,
    # created_at timestamp without time zone NOT NULL,
    # updated_at timestamp without time zone NOT NULL,
    # deleted_at timestamp without time zone
