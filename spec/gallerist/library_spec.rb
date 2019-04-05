# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2016, Sebastian Staudt

describe Gallerist::Library do

  let :library do
    db_path = '/some/library.photoslibrary/Database/Library.apdb'
    allow(File).to receive(:realpath).and_return db_path

    Gallerist::Library.new '/some/library.photoslibrary'
  end

  it 'should raise LibraryNonExistant error if the library does not exist' do
    allow(File).to receive(:realpath).and_raise Errno::ENOENT

    expect { Gallerist::Library.new '/wrong/path' }.to \
      raise_error(Gallerist::LibraryNonExistant)
  end

  it 'should know its name and paths' do
    expect(library.name).to eq('library')
    expect(library.path).to eq('/some/library.photoslibrary')
    expect(library.db_path).to eq('/some/library.photoslibrary/Database')
  end

  it 'should have albums' do
    all_albums = double
    allow(Gallerist::Album).to receive(:all).and_return all_albums

    expect(library.albums).to eq(all_albums)
  end

  it 'should have an application ID' do
    app_id = double
    allow(app_id).to \
      receive(:pluck).with(:propertyValue).and_return [ 'com.apple.Photos' ]
    allow(Gallerist::AdminData).to \
      receive(:where).with(propertyArea: 'database', propertyName: 'applicationIdentifier').and_return app_id

    expect(library.app_id).to eq('com.apple.Photos')
    expect(library.instance_variable_get :@app_id).to eq('com.apple.Photos')
  end

  it 'should be able to copy the main database to a temporary location' do
    expect(library).to receive(:copy_tmp_db).with 'photos.db'

    library.copy_base_db
  end

  it 'should be able to copy database files to a temporary location' do
    allow(Gallerist::App).to receive(:tempdir).and_return '/tmp'

    db_path = '/some/library.photoslibrary/Database/Library.apdb'
    tmp_path = '/tmp/Library.apdb'

    expect(FileUtils).to receive(:cp).with db_path, tmp_path, preserve: true

    library.copy_tmp_db 'Library.apdb'

    expect(library.db_path).to eq('/tmp')
  end

  it 'should know its database paths' do
    expect(library.db_path).to eq('/some/library.photoslibrary/Database')
    expect(library.image_proxies_db).to eq('/some/library.photoslibrary/Database/ImageProxies.apdb')
    expect(library.library_db).to eq('/some/library.photoslibrary/Database/photos.db')
  end

  it 'should have a human-readable text representation' do
    expect(library.inspect).to eq("#<Gallerist::Library path='/some/library.photoslibrary'>")
  end

  it 'should have persons' do
    all_persons = double
    allow(Gallerist::Person).to receive(:all).and_return all_persons

    expect(library.persons).to eq(all_persons)
  end

  it 'should have photos' do
    all_photos = double
    allow(Gallerist::Photo).to receive(:all).and_return all_photos

    expect(library.photos).to eq(all_photos)
  end

  it 'should have tags' do
    all_tags = double
    allow(Gallerist::Tag).to receive(:all).and_return all_tags

    expect(library.tags).to eq(all_tags)
  end

  context 'for a iPhoto library' do

    before do
      library.instance_variable_set :@app_id, 'com.apple.iPhoto'
      library.instance_variable_set :@legacy, true
    end

    it 'should be able to copy extra databases to a temporary location' do
      expect(library).to receive(:copy_tmp_db).with 'ImageProxies.apdb'
      expect(library).to receive(:copy_tmp_db).with 'Faces.db'

      library.copy_extra_dbs
    end

    it 'should be an iPhoto library' do
      expect(library.iphoto?).to be_truthy
    end

    it 'should know the path of the person database' do
      expect(library.person_db).to eq('/some/library.photoslibrary/Database/Faces.db')
    end

    it 'should have a type of :iphoto' do
      expect(library.type).to eq(:iphoto)
    end

  end

  context 'for a legacy Photos library' do

    before do
      library.instance_variable_set :@app_id, 'com.apple.Photos'
      library.instance_variable_set :@legacy, true
    end

    it 'should be able to copy extra databases to a temporary location' do
      expect(library).to receive(:copy_tmp_db).with 'ImageProxies.apdb'
      expect(library).to receive(:copy_tmp_db).with 'Person.db'

      library.copy_extra_dbs
    end

    it 'should not be an iPhoto library' do
      expect(library.iphoto?).to be_falsey
    end

    it 'should know the path of the person database' do
      expect(library.person_db).to eq('/some/library.photoslibrary/Database/Person.db')
    end

    it 'should have a type of :photos' do
      expect(library.type).to eq(:legacy_photos)
    end

  end

  context 'for a Photos library' do

    before do
      library.instance_variable_set :@app_id, 'com.apple.Photos'
    end

    it 'should be able to copy extra databases to a temporary location' do
      expect(library).not_to receive(:copy_tmp_db)

      library.copy_extra_dbs
    end

    it 'should not be an iPhoto library' do
      expect(library.iphoto?).to be_falsey
    end

    it 'should know the path of the person database' do
      expect(library.person_db).to eq('/some/library.photoslibrary/Database/Person.db')
    end

    it 'should have a type of :photos' do
      expect(library.type).to eq(:photos)
    end

  end

  context 'its file helper' do

    before do
      allow(Dir).to receive(:glob) { |file, _| file }
    end

    it 'should fail gracefully' do
      allow(Dir).to \
        receive(:glob).with('/some/file', File::FNM_CASEFOLD).
        and_return []

      expect(library.file '/some', 'file').to eq('/some/file')
    end

    it 'should return the first matching path' do
      allow(Dir).to \
        receive(:glob).with('/some/file', File::FNM_CASEFOLD).
        and_return [ '/some/FILE' ]

      expect(library.file '/some', 'file').to eq('/some/FILE')
    end

  end

end
