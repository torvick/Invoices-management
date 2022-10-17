# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

CodeError.create!(name:'set_invoice', description:"Couldn't find invoice with id", value: 10001, status: true)
CodeError.create!(name:'set_emitter', description:"Couldn't find emitter with id", value: 20001, status: true)
CodeError.create!(name:'set_receiver', description:"Couldn't find receiver with id", value: 30001, status: true)
