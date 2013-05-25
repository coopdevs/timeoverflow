require 'translates'

class Category < ActiveRecord::Base
  extend Translates
  acts_as_tree

  belongs_to :parent,
        class_name: "Category",
        foreign_key: :parent_id,
        counter_cache: :children_count
  translates :name, :fqn
  attr_accessible :name_translations, :parent_id
  belongs_to :organization

  has_and_belongs_to_many :users

  after_save :recalculate_descendent_fqns, :if => :name_translations_changed?

  has_many :transfers

  has_many :user, :through => :transfer

  FQN_SEPARATOR = " > "

  def calculate_fqn
    self_and_ancestors.reverse.inject(Hash.new) do |memo, cat|
      I18n.available_locales.each do |lo|
        memo[lo] ||= ""
        memo[lo] << FQN_SEPARATOR unless memo[lo].blank?
        memo[lo] << cat.send("name_#{lo}").to_s
      end
      memo
    end
  end

  def setup_fqn
    self.fqn_translations = calculate_fqn
    save
  end

  def recalculate_descendent_fqns
    reload.self_and_descendants.each &:setup_fqn
  end

  def to_s
    name
  end


end
