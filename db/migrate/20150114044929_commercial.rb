class Commercial < ActiveRecord::Migration
  def change
    create_table :commercials do |t|
      t.string :a_c, :limit => 100
      t.text :ad_text
      t.string :addr, :limit => 100
      t.integer :amps
      t.string :apt_num, :limit => 100
      t.string :area, :limit => 100
      t.string :area_code, :limit => 100
      t.string :area_infl1_out, :limit => 100
      t.string :area_infl2_out, :limit => 100
      t.integer :ass_year, :limit => 4
      t.integer :bath_tot, :limit => 2
      t.integer :bay_size1, :limit => 2
      t.integer :bay_size1_in, :limit => 2
      t.integer :bay_size2, :limit => 2
      t.integer :bay_size2_in, :limit => 2
      t.string :bsmt1_out, :limit => 100
      t.string :bus_type, :limit => 100
      t.integer :ceil_ht, :limit => 2
      t.integer :ceil_ht_in, :limit => 2
      t.string :cert_lvl, :limit => 100
      t.string :chattels, :limit => 100
      t.integer :com_chgs, :limit => 3
      t.integer :com_cn_fee, :limit => 8
      t.string :community, :limit => 100
      t.string :community_code, :limit => 100
      t.string :county, :limit => 100
      t.string :crane, :limit => 100
      t.string :cross_st, :limit => 100
      t.string :days_open, :limit => 100
      t.string :dba, :limit => 100
      t.decimal :depth, :precision => 6, :scale => 2
      t.string :disp_addr, :limit => 100
      t.integer :DOM, :limit => 5
      t.string :elevator, :limit => 100
      t.integer :employees, :limit => 2
      t.string :energy_cert, :limit => 100
      t.string :exp_actest, :limit => 3
      t.text :extras
      t.string :fin_stmnt, :limit => 100
      t.string :franchise, :limit => 100
      t.string :freestandg, :limit => 100
      t.decimal :front_ft, :precision => 8, :scale => 2
      t.string :gar_type, :limit => 100
      t.string :green_pis, :limit => 100
      t.integer :gross_inc, :limit => 8
      t.string :handi_equipped, :limit => 100
      t.integer :heat_exp, :limit => 7
      t.string :heating, :limit => 100
      t.string :hours_open, :limit => 100
      t.integer :hydro_exp, :limit => 7
      t.integer :ind_area, :limit => 7
      t.string :ind_areacd, :limit => 100
      t.integer :insur, :limit => 7
      t.integer :inventory, :limit => 8
      t.string :irreg, :limit => 100
      t.string :llbo, :limit => 100
      t.string :lot_code, :limit => 100
      t.string :lotsz_code, :limit => 100
      t.string :lp_code, :limit => 100
      t.decimal :lp_dol, :precision => 11, :scale => 2
      t.decimal :maint, :precision => 7, :scale => 2
      t.integer :mgmt, :limit => 7
      t.integer :minrenttrm, :limit => 3
      t.string :ml_num, :limit => 100
      t.integer :mmap_col, :limit => 2
      t.integer :mmap_page, :limit => 3
      t.string :mmap_row, :limit => 100
      t.string :municipality, :limit => 100
      t.string :municipality_code, :limit => 100
      t.string :municipality_district, :limit => 100
      t.integer :net_inc, :limit => 8
      t.integer :oa_area, :limit => 7
      t.string :occ, :limit => 100
      t.string :off_areacd, :limit => 100
      t.integer :oper_exp, :limit => 8
      t.integer :other, :limit => 7
      t.string :out_storg, :limit => 100
      t.string :outof_area, :limit => 100
      t.string :parcel_id, :limit => 100
      t.integer :park_spcs, :limit => 3
      t.integer :perc_bldg, :limit => 3
      t.integer :perc_rent, :limit => 3
      t.datetime :pix_updt
      t.string :prop_type, :limit => 100
      t.string :rail, :limit => 100
      t.integer :retail_a, :limit => 7
      t.string :retail_ac, :limit => 100
      t.string :rltr, :limit => 100
      t.string :s_r, :limit => 100
      t.integer :seats, :limit => 3
      t.string :sewer, :limit => 100
      t.integer :shpdrsdlhtft, :limit => 2
      t.integer :shpdrsdlhtin, :limit => 2
      t.integer :shpdrsdlnu, :limit => 2
      t.integer :shpdrsdlwdft, :limit => 2
      t.integer :shpdrsdlwdin, :limit => 2
      t.integer :shpdrsdmhtft, :limit => 2
      t.integer :shpdrsdmhtin, :limit => 2
      t.integer :shpdrsdmnu, :limit => 2
      t.integer :shpdrsdmwdft, :limit => 2
      t.integer :shpdrsdmwdin, :limit => 2
      t.integer :shpdrsglhtft, :limit => 2
      t.integer :shpdrsglhtin, :limit => 2
      t.integer :shpdrsglnu, :limit => 2
      t.integer :shpdrsglwdft, :limit => 2
      t.integer :shpdrsglwdin, :limit => 2
      t.integer :shpdrstlhtft, :limit => 2
      t.integer :shpdrstlhtin, :limit => 2
      t.integer :shpdrstlnu, :limit => 2
      t.integer :shpdrstlwdft, :limit => 2
      t.integer :shpdrstlwdin, :limit => 2
      t.string :soil_test, :limit => 100
      t.string :sprinklers, :limit => 100
      t.string :st, :limit => 100
      t.string :st_dir, :limit => 100
      t.string :st_num, :limit => 100
      t.string :st_sfx, :limit => 100
      t.string :status, :limit => 100
      t.string :survey, :limit => 100
      t.decimal :taxes, :precision => 8, :scale => 2
      t.integer :taxes_exp, :limit => 7
      t.integer :terms, :limit => 3
      t.datetime :timestamp_sql
      t.decimal :tot_area, :precision => 10, :scale => 2
      t.string :tot_areacd, :limit => 100
      t.integer :trlr_pk_spt, :limit => 4
      t.integer :tv, :limit => 8
      t.string :type_own_srch, :limit => 100
      t.string :type_own1_out, :limit => 100
      t.string :type_taxes, :limit => 100
      t.string :uffi, :limit => 100
      t.string :utilities, :limit => 100
      t.integer :vac_perc, :limit => 8
      t.string :vend_pis, :limit => 100
      t.integer :volts, :limit => 3
      t.string :water, :limit => 100
      t.integer :water_exp, :limit => 7
      t.string :wtr_suptyp, :limit => 100
      t.integer :yr, :limit => 4
      t.string :yr_built, :limit => 100
      t.integer :yr_exp, :limit => 4
      t.string :zip, :limit => 100
      t.string :zoning, :limit => 100
      t.timestamps null: false
    end
  end
end
